| **Action**       | **RBAC Verb**                         | **K8s Resource Examples**               |
| ---------------- | ------------------------------------- | --------------------------------------- |
| View resources   | `get`, `list`, `watch`                | `pods`, `services`, `deployments`, etc. |
| Modify resources | `create`, `update`, `patch`, `delete` | Same as above                           |
| Exec into pods   | `create` on `pods/exec`               | `pods/exec`                             |
| Port forwarding  | `create` on `pods/portforward`        | `pods/portforward`                      |
| View logs        | `get` on `pods/log`                   | `pods/log`                              |
| Manage nodes     | `get`, `list` on `nodes`              | `nodes`                                 |
| Manage RBAC      | `create`, `bind`, `escalate`, etc.    | `roles`, `rolebindings`, etc.           |
| Manage CRDs      | Depends on group/version              | Custom resources                        |
| Full admin       | `*` on `*`                            | All                                     |

| **Role**     | **Scope**    | **Purpose**                      |
| ------------ | ------------ | -------------------------------- |
| `admin`      | Cluster-wide | Full access                      |
| `edit`       | Namespace    | Modify all resources (not RBAC)  |
| `view`       | Namespace    | Read-only                        |
| Custom roles | Fine-grained | e.g., exec-only, logs-only, etc. |
