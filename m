Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935152AbeCHClH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 07709AE67
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:06 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 16/20] btrfs-progs: pass cmd_struct to usage()
Date: Wed,  7 Mar 2018 21:40:43 -0500
Message-Id: <20180308024047.10104-17-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Now that every call site has a cmd_struct, we can just pass the cmd_struct
to usage to print the usager information.  This allows us to interpret
the format flags we'll add later in this series to inform the user of
which output formats any given command supports.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs-calc-size.c         |  2 +-
 btrfs-debug-tree.c        |  2 +-
 btrfs-show-super.c        |  2 +-
 check/main.c              |  4 ++--
 cmds-balance.c            | 14 +++++++-------
 cmds-device.c             | 19 +++++++++----------
 cmds-fi-du.c              |  4 ++--
 cmds-fi-usage.c           |  4 ++--
 cmds-filesystem.c         | 18 +++++++++---------
 cmds-inspect-dump-super.c |  4 ++--
 cmds-inspect-dump-tree.c  |  4 ++--
 cmds-inspect-tree-stats.c |  4 ++--
 cmds-inspect.c            | 16 ++++++++--------
 cmds-property.c           | 22 +++++++++-------------
 cmds-qgroup.c             | 18 +++++++++---------
 cmds-quota.c              |  8 ++++----
 cmds-receive.c            |  4 ++--
 cmds-replace.c            | 12 ++++++------
 cmds-rescue.c             | 12 ++++++------
 cmds-restore.c            |  8 ++++----
 cmds-scrub.c              | 25 ++++++++++---------------
 cmds-send.c               |  2 +-
 cmds-subvolume.c          | 30 +++++++++++++++---------------
 help.c                    |  6 +++---
 help.h                    |  2 +-
 25 files changed, 118 insertions(+), 128 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 908e830f..4c8fcc19 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -30,7 +30,7 @@ int main(int argc, char **argv)
 "\nthe tool has been deprecated, please use 'btrfs inspect-internal tree-stats' instead\n");
 
 	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd->usagestr);
+		usage(cmd);
 
 	ret = cmd_execute(cmd, argc, argv);
 
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 7f254519..49a2e949 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -30,7 +30,7 @@ int main(int argc, char **argv)
 	set_argv0(argv);
 
 	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd->usagestr);
+		usage(cmd);
 
 	radix_tree_init();
 
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index ee717c33..b4a5b693 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -31,7 +31,7 @@ int main(int argc, char **argv)
 "\nthe tool has been deprecated, please use 'btrfs inspect-internal dump-super' instead\n");
 
 	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd->usagestr);
+		usage(cmd);
 
 	ret = cmd_execute(cmd, argc, argv);
 
diff --git a/check/main.c b/check/main.c
index bd31fb9f..0bb8633a 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9530,7 +9530,7 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 				break;
 			case '?':
 			case 'h':
-				usage(cmd_check_usage);
+				usage(cmd);
 			case GETOPT_VAL_REPAIR:
 				printf("enabling repair mode\n");
 				repair = 1;
@@ -9581,7 +9581,7 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_check_usage);
+		usage(cmd);
 
 	if (ctx.progress_enabled) {
 		ctx.tp = TASK_NOTHING;
diff --git a/cmds-balance.c b/cmds-balance.c
index 488fffcc..c639459f 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -585,12 +585,12 @@ static int cmd_balance_start(const struct cmd_struct *cmd,
 			background = 1;
 			break;
 		default:
-			usage(cmd_balance_start_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_balance_start_usage);
+		usage(cmd);
 
 	/*
 	 * allow -s only under --force, otherwise do with system chunks
@@ -692,7 +692,7 @@ static int cmd_balance_pause(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_balance_pause_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
@@ -732,7 +732,7 @@ static int cmd_balance_cancel(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_balance_cancel_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
@@ -773,7 +773,7 @@ static int cmd_balance_resume(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_balance_resume_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
@@ -856,12 +856,12 @@ static int cmd_balance_status(const struct cmd_struct *cmd,
 			verbose = 1;
 			break;
 		default:
-			usage(cmd_balance_status_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_balance_status_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
diff --git a/cmds-device.c b/cmds-device.c
index 5be748f7..6c74ca8e 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -77,12 +77,12 @@ static int cmd_device_add(const struct cmd_struct *cmd,
 			force = 1;
 			break;
 		default:
-			usage(cmd_device_add_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 2))
-		usage(cmd_device_add_usage);
+		usage(cmd);
 
 	last_dev = argc - 1;
 	mntpnt = argv[last_dev];
@@ -149,12 +149,11 @@ static int _cmd_device_remove(const struct cmd_struct *cmd,
 	char	*mntpnt;
 	int i, fdmnt, ret = 0;
 	DIR	*dirstream = NULL;
-	const char * const *usagestr = cmd->usagestr;
 
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_min(argc - optind, 2))
-		usage(usagestr);
+		usage(cmd);
 
 	mntpnt = argv[argc - 1];
 
@@ -290,13 +289,13 @@ static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
 			all = 1;
 			break;
 		default:
-			usage(cmd_device_scan_usage);
+			usage(cmd);
 		}
 	}
 	devstart = optind;
 
 	if (all && check_argc_max(argc - optind, 1))
-		usage(cmd_device_scan_usage);
+		usage(cmd);
 
 	if (all || argc - optind == 0) {
 		printf("Scanning for Btrfs filesystems\n");
@@ -351,7 +350,7 @@ static int cmd_device_ready(const struct cmd_struct *cmd, int argc, char **argv)
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_device_ready_usage);
+		usage(cmd);
 
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
@@ -434,12 +433,12 @@ static int cmd_device_stats(const struct cmd_struct *cmd, int argc, char **argv)
 			break;
 		case '?':
 		default:
-			usage(cmd_device_stats_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_device_stats_usage);
+		usage(cmd);
 
 	dev_path = argv[optind];
 
@@ -577,7 +576,7 @@ static int cmd_device_usage(const struct cmd_struct *cmd, int argc, char **argv)
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_device_usage_usage);
+		usage(cmd);
 
 	for (i = optind; i < argc; i++) {
 		int fd;
diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index a86f4ad6..ebcb0c15 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -580,12 +580,12 @@ static int cmd_filesystem_du(const struct cmd_struct *cmd,
 			summarize = 1;
 			break;
 		default:
-			usage(cmd_filesystem_du_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_filesystem_du_usage);
+		usage(cmd);
 
 	kernel_version = get_running_kernel_version();
 
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 36684762..6da96411 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -988,12 +988,12 @@ static int cmd_filesystem_usage(const struct cmd_struct *cmd,
 			tabular = 1;
 			break;
 		default:
-			usage(cmd_filesystem_usage_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_filesystem_usage_usage);
+		usage(cmd);
 
 	for (i = optind; i < argc; i++) {
 		int fd;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b793532b..8ddb7ea5 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -130,7 +130,7 @@ static int cmd_filesystem_df(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_filesystem_df_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
@@ -705,17 +705,17 @@ static int cmd_filesystem_show(const struct cmd_struct *cmd,
 			where = BTRFS_SCAN_MOUNTED;
 			break;
 		default:
-			usage(cmd_filesystem_show_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_max(argc, optind + 1))
-		usage(cmd_filesystem_show_usage);
+		usage(cmd);
 
 	if (argc > optind) {
 		search = argv[optind];
 		if (*search == 0)
-			usage(cmd_filesystem_show_usage);
+			usage(cmd);
 		type = check_arg_type(search);
 
 		/*
@@ -825,7 +825,7 @@ static int cmd_filesystem_sync(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_filesystem_sync_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
@@ -974,12 +974,12 @@ static int cmd_filesystem_defrag(const struct cmd_struct *cmd,
 			recursive = 1;
 			break;
 		default:
-			usage(cmd_filesystem_defrag_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_filesystem_defrag_usage);
+		usage(cmd);
 
 	memset(&defrag_global_range, 0, sizeof(defrag_global_range));
 	defrag_global_range.start = start;
@@ -1105,7 +1105,7 @@ static int cmd_filesystem_resize(const struct cmd_struct *cmd,
 	clean_args_no_options_relaxed(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 2))
-		usage(cmd_filesystem_resize_usage);
+		usage(cmd);
 
 	amount = argv[optind];
 	path = argv[optind + 1];
@@ -1179,7 +1179,7 @@ static int cmd_filesystem_label(const struct cmd_struct *cmd,
 
 	if (check_argc_min(argc - optind, 1) ||
 			check_argc_max(argc - optind, 2))
-		usage(cmd_filesystem_label_usage);
+		usage(cmd);
 
 	if (argc - optind > 1) {
 		return set_label(argv[optind], argv[optind + 1]);
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index ca503a2e..6341d2ac 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -573,12 +573,12 @@ static int cmd_inspect_dump_super(const struct cmd_struct *cmd,
 			all = 0;
 			break;
 		default:
-			usage(cmd_inspect_dump_super_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_inspect_dump_super_usage);
+		usage(cmd);
 
 	for (i = optind; i < argc; i++) {
 		filename = argv[i];
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 5cc39a88..22bc9cb9 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -288,12 +288,12 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 			break;
 			}
 		default:
-			usage(cmd_inspect_dump_tree_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_inspect_dump_tree_usage);
+		usage(cmd);
 
 	ret = check_arg_type(argv[optind]);
 	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index 64ca3d0b..e5e68562 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -444,12 +444,12 @@ static int cmd_inspect_tree_stats(const struct cmd_struct *cmd,
 			no_pretty = 1;
 			break;
 		default:
-			usage(cmd_inspect_tree_stats_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1)) {
-		usage(cmd_inspect_tree_stats_usage);
+		usage(cmd);
 	}
 
 	ret = check_mounted(argv[optind]);
diff --git a/cmds-inspect.c b/cmds-inspect.c
index ece8c8d4..bc86e999 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -105,12 +105,12 @@ static int cmd_inspect_inode_resolve(const struct cmd_struct *cmd,
 			verbose = 1;
 			break;
 		default:
-			usage(cmd_inspect_inode_resolve_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 2))
-		usage(cmd_inspect_inode_resolve_usage);
+		usage(cmd);
 
 	fd = btrfs_open_dir(argv[optind + 1], &dirstream, 1);
 	if (fd < 0)
@@ -167,12 +167,12 @@ static int cmd_inspect_logical_resolve(const struct cmd_struct *cmd,
 			size = arg_strtou64(optarg);
 			break;
 		default:
-			usage(cmd_inspect_logical_resolve_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 2))
-		usage(cmd_inspect_logical_resolve_usage);
+		usage(cmd);
 
 	size = min(size, (u64)SZ_64K);
 	inodes = malloc(size);
@@ -280,7 +280,7 @@ static int cmd_inspect_subvolid_resolve(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 2))
-		usage(cmd_inspect_subvolid_resolve_usage);
+		usage(cmd);
 
 	fd = btrfs_open_dir(argv[optind + 1], &dirstream, 1);
 	if (fd < 0) {
@@ -323,7 +323,7 @@ static int cmd_inspect_rootid(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_inspect_rootid_usage);
+		usage(cmd);
 
 	fd = btrfs_open_file_or_dir(argv[optind], &dirstream, 1);
 	if (fd < 0) {
@@ -617,11 +617,11 @@ static int cmd_inspect_min_dev_size(const struct cmd_struct *cmd,
 			devid = arg_strtou64(optarg);
 			break;
 		default:
-			usage(cmd_inspect_min_dev_size_usage);
+			usage(cmd);
 		}
 	}
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_inspect_min_dev_size_usage);
+		usage(cmd);
 
 	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
 	if (fd < 0) {
diff --git a/cmds-property.c b/cmds-property.c
index 5684443c..4aa2f18f 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -256,8 +256,7 @@ out:
 
 }
 
-static void parse_args(int argc, char **argv,
-		       const char * const *usage_str,
+static void parse_args(const struct cmd_struct *cmd, int argc, char **argv,
 		       int *types, char **object,
 		       char **name, char **value, int min_nonopt_args)
 {
@@ -276,7 +275,7 @@ static void parse_args(int argc, char **argv,
 			type_str = optarg;
 			break;
 		default:
-			usage(usage_str);
+			usage(cmd);
 		}
 	}
 
@@ -287,7 +286,7 @@ static void parse_args(int argc, char **argv,
 
 	if (check_argc_min(argc - optind, min_nonopt_args) ||
 	    check_argc_max(argc - optind, max_nonopt_args))
-		usage(usage_str);
+		usage(cmd);
 
 	*types = 0;
 	if (type_str) {
@@ -304,7 +303,7 @@ static void parse_args(int argc, char **argv,
 			*types = prop_object_dev;
 		} else {
 			error("invalid object type: %s", type_str);
-			usage(usage_str);
+			usage(cmd);
 		}
 	}
 
@@ -319,11 +318,11 @@ static void parse_args(int argc, char **argv,
 		if (ret < 0) {
 			error("failed to detect object type: %s",
 				strerror(-ret));
-			usage(usage_str);
+			usage(cmd);
 		}
 		if (!*types) {
 			error("object is not a btrfs object: %s", *object);
-			usage(usage_str);
+			usage(cmd);
 		}
 	}
 }
@@ -349,8 +348,7 @@ static int cmd_property_get(const struct cmd_struct *cmd,
 	char *name = NULL;
 	int types = 0;
 
-	parse_args(argc, argv, cmd_property_get_usage, &types, &object, &name,
-		   NULL, 1);
+	parse_args(cmd, argc, argv, &types, &object, &name, NULL, 1);
 
 	if (name)
 		ret = setget_prop(types, object, name, NULL);
@@ -378,8 +376,7 @@ static int cmd_property_set(const struct cmd_struct *cmd,
 	char *value = NULL;
 	int types = 0;
 
-	parse_args(argc, argv, cmd_property_set_usage, &types,
-		   &object, &name, &value, 3);
+	parse_args(cmd, argc, argv, &types, &object, &name, &value, 3);
 
 	ret = setget_prop(types, object, name, value);
 
@@ -402,8 +399,7 @@ static int cmd_property_list(const struct cmd_struct *cmd,
 	char *object = NULL;
 	int types = 0;
 
-	parse_args(argc, argv, cmd_property_list_usage,
-		   &types, &object, NULL, NULL, 1);
+	parse_args(cmd, argc, argv, &types, &object, NULL, NULL, 1);
 
 	ret = dump_props(types, object, 1);
 
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 6e59c559..986f272c 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -74,7 +74,7 @@ static int _cmd_qgroup_assign(const struct cmd_struct *cmd, int assign,
 	}
 
 	if (check_argc_exact(argc - optind, 3))
-		usage(cmd->usagestr);
+		usage(cmd);
 
 	memset(&args, 0, sizeof(args));
 	args.assign = assign;
@@ -251,7 +251,7 @@ static int cmd_qgroup_create(const struct cmd_struct *cmd,
 	ret = _cmd_qgroup_create(1, argc, argv);
 
 	if (ret < 0)
-		usage(cmd_qgroup_create_usage);
+		usage(cmd);
 	return ret;
 }
 static DEFINE_SIMPLE_COMMAND(qgroup_create, "create");
@@ -272,7 +272,7 @@ static int cmd_qgroup_destroy(const struct cmd_struct *cmd,
 	ret = _cmd_qgroup_create(0, argc, argv);
 
 	if (ret < 0)
-		usage(cmd_qgroup_destroy_usage);
+		usage(cmd);
 	return ret;
 }
 static DEFINE_SIMPLE_COMMAND(qgroup_destroy, "destroy");
@@ -366,7 +366,7 @@ static int cmd_qgroup_show(const struct cmd_struct *cmd, int argc, char **argv)
 			ret = btrfs_qgroup_parse_sort_string(optarg,
 							     &comparer_set);
 			if (ret)
-				usage(cmd_qgroup_show_usage);
+				usage(cmd);
 			break;
 		case GETOPT_VAL_SYNC:
 			sync = 1;
@@ -375,13 +375,13 @@ static int cmd_qgroup_show(const struct cmd_struct *cmd, int argc, char **argv)
 			verbose = true;
 			break;
 		default:
-			usage(cmd_qgroup_show_usage);
+			usage(cmd);
 		}
 	}
 	btrfs_qgroup_setup_units(unit_mode);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_qgroup_show_usage);
+		usage(cmd);
 
 	path = argv[optind];
 	fd = btrfs_open_dir(path, &dirstream, 1);
@@ -457,12 +457,12 @@ static int cmd_qgroup_limit(const struct cmd_struct *cmd, int argc, char **argv)
 			exclusive = 1;
 			break;
 		default:
-			usage(cmd_qgroup_limit_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 2))
-		usage(cmd_qgroup_limit_usage);
+		usage(cmd);
 
 	if (!parse_limit(argv[optind], &size)) {
 		error("invalid size argument: %s", argv[optind]);
@@ -501,7 +501,7 @@ static int cmd_qgroup_limit(const struct cmd_struct *cmd, int argc, char **argv)
 		args.qgroupid = parse_qgroupid(argv[optind + 1]);
 		path = argv[optind + 2];
 	} else
-		usage(cmd_qgroup_limit_usage);
+		usage(cmd);
 
 	fd = btrfs_open_dir(path, &dirstream, 1);
 	if (fd < 0)
diff --git a/cmds-quota.c b/cmds-quota.c
index 23757f9a..c634c4e9 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -76,7 +76,7 @@ static int cmd_quota_enable(const struct cmd_struct *cmd, int argc, char **argv)
 	ret = quota_ctl(BTRFS_QUOTA_CTL_ENABLE, argc, argv);
 
 	if (ret < 0)
-		usage(cmd_quota_enable_usage);
+		usage(cmd);
 	return ret;
 }
 static DEFINE_SIMPLE_COMMAND(quota_enable, "enable");
@@ -97,7 +97,7 @@ static int cmd_quota_disable(const struct cmd_struct *cmd,
 	ret = quota_ctl(BTRFS_QUOTA_CTL_DISABLE, argc, argv);
 
 	if (ret < 0)
-		usage(cmd_quota_disable_usage);
+		usage(cmd);
 	return ret;
 }
 static DEFINE_SIMPLE_COMMAND(quota_disable, "disable");
@@ -140,7 +140,7 @@ static int cmd_quota_rescan(const struct cmd_struct *cmd, int argc, char **argv)
 			wait_for_completion = 1;
 			break;
 		default:
-			usage(cmd_quota_rescan_usage);
+			usage(cmd);
 		}
 	}
 
@@ -150,7 +150,7 @@ static int cmd_quota_rescan(const struct cmd_struct *cmd, int argc, char **argv)
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_quota_rescan_usage);
+		usage(cmd);
 
 	memset(&args, 0, sizeof(args));
 
diff --git a/cmds-receive.c b/cmds-receive.c
index 93c1838d..5429c607 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1352,9 +1352,9 @@ static int cmd_receive(const struct cmd_struct *cmd, int argc, char **argv)
 	}
 
 	if (dump && check_argc_exact(argc - optind, 0))
-		usage(cmd_receive_usage);
+		usage(cmd);
 	if (!dump && check_argc_exact(argc - optind, 1))
-		usage(cmd_receive_usage);
+		usage(cmd);
 
 	tomnt = argv[optind];
 
diff --git a/cmds-replace.c b/cmds-replace.c
index f1e76bdf..2057d69e 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -148,7 +148,7 @@ static int cmd_replace_start(const struct cmd_struct *cmd,
 			break;
 		case '?':
 		default:
-			usage(cmd_replace_start_usage);
+			usage(cmd);
 		}
 	}
 
@@ -157,7 +157,7 @@ static int cmd_replace_start(const struct cmd_struct *cmd,
 		 BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID :
 		 BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS;
 	if (check_argc_exact(argc - optind, 3))
-		usage(cmd_replace_start_usage);
+		usage(cmd);
 	path = argv[optind + 2];
 
 	fdmnt = open_path_or_dev_mnt(path, &dirstream, 1);
@@ -343,12 +343,12 @@ static int cmd_replace_status(const struct cmd_struct *cmd,
 			break;
 		case '?':
 		default:
-			usage(cmd_replace_status_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_replace_status_usage);
+		usage(cmd);
 
 	path = argv[optind];
 	fd = btrfs_open_dir(path, &dirstream, 1);
@@ -510,12 +510,12 @@ static int cmd_replace_cancel(const struct cmd_struct *cmd,
 		switch (c) {
 		case '?':
 		default:
-			usage(cmd_replace_cancel_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_replace_cancel_usage);
+		usage(cmd);
 
 	path = argv[optind];
 	fd = btrfs_open_dir(path, &dirstream, 1);
diff --git a/cmds-rescue.c b/cmds-rescue.c
index 975ff05a..f96d8010 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -66,12 +66,12 @@ static int cmd_rescue_chunk_recover(const struct cmd_struct *cmd,
 			break;
 		case 'h':
 		default:
-			usage(cmd_rescue_chunk_recover_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_rescue_chunk_recover_usage);
+		usage(cmd);
 
 	file = argv[optind];
 
@@ -134,11 +134,11 @@ static int cmd_rescue_super_recover(const struct cmd_struct *cmd,
 			yes = 1;
 			break;
 		default:
-			usage(cmd_rescue_super_recover_usage);
+			usage(cmd);
 		}
 	}
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_rescue_super_recover_usage);
+		usage(cmd);
 
 	dname = argv[optind];
 	ret = check_mounted(dname);
@@ -173,7 +173,7 @@ static int cmd_rescue_zero_log(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc, 2))
-		usage(cmd_rescue_zero_log_usage);
+		usage(cmd);
 
 	devname = argv[optind];
 	ret = check_mounted(devname);
@@ -226,7 +226,7 @@ static int cmd_rescue_fix_device_size(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc, 2))
-		usage(cmd_rescue_fix_device_size_usage);
+		usage(cmd);
 
 	devname = argv[optind];
 	ret = check_mounted(devname);
diff --git a/cmds-restore.c b/cmds-restore.c
index e850ec97..87cfb582 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1415,7 +1415,7 @@ static const char * const cmd_restore_usage[] = {
 	NULL
 };
 
-static int cmd_restore(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_restore(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
@@ -1518,14 +1518,14 @@ static int cmd_restore(const struct cmd_struct *unused, int argc, char **argv)
 				get_xattrs = 1;
 				break;
 			default:
-				usage(cmd_restore_usage);
+				usage(cmd);
 		}
 	}
 
 	if (!list_roots && check_argc_min(argc - optind, 2))
-		usage(cmd_restore_usage);
+		usage(cmd);
 	else if (list_roots && check_argc_min(argc - optind, 1))
-		usage(cmd_restore_usage);
+		usage(cmd);
 
 	if (fs_location && root_objectid) {
 		fprintf(stderr, "don't use -f and -r at the same time.\n");
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 9917a2f4..872c996b 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1094,10 +1094,8 @@ static int is_scrub_running_in_kernel(int fd,
 	return 0;
 }
 
-static const char * const cmd_scrub_start_usage[];
-static const char * const cmd_scrub_resume_usage[];
-
-static int scrub_start(int argc, char **argv, bool resume)
+static int scrub_start(const struct cmd_struct *cmd, int argc, char **argv,
+		       bool resume)
 {
 	int fdmnt;
 	int prg_fd = -1;
@@ -1176,17 +1174,14 @@ static int scrub_start(int argc, char **argv, bool resume)
 			break;
 		case '?':
 		default:
-			usage(resume ? cmd_scrub_resume_usage :
-						cmd_scrub_start_usage);
+			usage(cmd);
 		}
 	}
 
 	/* try to catch most error cases before forking */
 
-	if (check_argc_exact(argc - optind, 1)) {
-		usage(resume ? cmd_scrub_resume_usage :
-					cmd_scrub_start_usage);
-	}
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd);
 
 	spc.progress = NULL;
 	if (do_quiet && do_print)
@@ -1578,7 +1573,7 @@ static const char * const cmd_scrub_start_usage[] = {
 
 static int cmd_scrub_start(const struct cmd_struct *cmd, int argc, char **argv)
 {
-	return scrub_start(argc, argv, false);
+	return scrub_start(cmd, argc, argv, false);
 }
 static DEFINE_SIMPLE_COMMAND(scrub_start, "start");
 
@@ -1598,7 +1593,7 @@ static int cmd_scrub_cancel(const struct cmd_struct *cmd, int argc, char **argv)
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_scrub_cancel_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
@@ -1645,7 +1640,7 @@ static const char * const cmd_scrub_resume_usage[] = {
 
 static int cmd_scrub_resume(const struct cmd_struct *cmd, int argc, char **argv)
 {
-	return scrub_start(argc, argv, true);
+	return scrub_start(cmd, argc, argv, true);
 }
 static DEFINE_SIMPLE_COMMAND(scrub_resume, "resume");
 
@@ -1691,12 +1686,12 @@ static int cmd_scrub_status(const struct cmd_struct *cmd, int argc, char **argv)
 			break;
 		case '?':
 		default:
-			usage(cmd_scrub_status_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_scrub_status_usage);
+		usage(cmd);
 
 	path = argv[optind];
 
diff --git a/cmds-send.c b/cmds-send.c
index bd501576..e2d87785 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -643,7 +643,7 @@ static int cmd_send(const struct cmd_struct *cmd, int argc, char **argv)
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_send_usage);
+		usage(cmd);
 
 	if (outname[0]) {
 		int tmpfd;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c577cc23..dc529315 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -150,12 +150,12 @@ static int cmd_subvol_create(const struct cmd_struct *cmd,
 			}
 			break;
 		default:
-			usage(cmd_subvol_create_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_subvol_create_usage);
+		usage(cmd);
 
 	dst = argv[optind];
 
@@ -295,12 +295,12 @@ static int cmd_subvol_delete(const struct cmd_struct *cmd,
 			verbose++;
 			break;
 		default:
-			usage(cmd_subvol_delete_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_subvol_delete_usage);
+		usage(cmd);
 
 	if (verbose > 0) {
 		printf("Transaction commit: %s\n",
@@ -633,7 +633,7 @@ out:
 	if (comparer_set)
 		free(comparer_set);
 	if (uerr)
-		usage(cmd_subvol_list_usage);
+		usage(cmd);
 	return !!ret;
 }
 static DEFINE_SIMPLE_COMMAND(subvol_list, "list");
@@ -698,12 +698,12 @@ static int cmd_subvol_snapshot(const struct cmd_struct *cmd,
 			}
 			break;
 		default:
-			usage(cmd_subvol_snapshot_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 2))
-		usage(cmd_subvol_snapshot_usage);
+		usage(cmd);
 
 	subvol = argv[optind];
 	dst = argv[optind + 1];
@@ -815,7 +815,7 @@ static int cmd_subvol_get_default(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_subvol_get_default_usage);
+		usage(cmd);
 
 	subvol = argv[1];
 	fd = btrfs_open_dir(subvol, &dirstream, 1);
@@ -884,7 +884,7 @@ static int cmd_subvol_set_default(const struct cmd_struct *cmd,
 
 	if (check_argc_min(argc - optind, 1) ||
 			check_argc_max(argc - optind, 2))
-		usage(cmd_subvol_set_default_usage);
+		usage(cmd);
 
 	if (argc - optind == 1) {
 		/* path to the subvolume is specified */
@@ -948,7 +948,7 @@ static int cmd_subvol_find_new(const struct cmd_struct *cmd,
 	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 2))
-		usage(cmd_subvol_find_new_usage);
+		usage(cmd);
 
 	subvol = argv[optind];
 	last_gen = arg_strtou64(argv[optind + 1]);
@@ -1037,17 +1037,17 @@ static int cmd_subvol_show(const struct cmd_struct *cmd, int argc, char **argv)
 			by_uuid = 1;
 			break;
 		default:
-			usage(cmd_subvol_show_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_exact(argc - optind, 1))
-		usage(cmd_subvol_show_usage);
+		usage(cmd);
 
 	if (by_rootid && by_uuid) {
 		error(
 		"options --rootid and --uuid cannot be used at the same time");
-		usage(cmd_subvol_show_usage);
+		usage(cmd);
 	}
 
 	memset(&get_ri, 0, sizeof(get_ri));
@@ -1369,12 +1369,12 @@ static int cmd_subvol_sync(const struct cmd_struct *cmd, int argc, char **argv)
 			}
 			break;
 		default:
-			usage(cmd_subvol_sync_usage);
+			usage(cmd);
 		}
 	}
 
 	if (check_argc_min(argc - optind, 1))
-		usage(cmd_subvol_sync_usage);
+		usage(cmd);
 
 	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
 	if (fd < 0) {
diff --git a/help.c b/help.c
index 23d6ea8f..6ee93161 100644
--- a/help.c
+++ b/help.c
@@ -101,7 +101,7 @@ void clean_args_no_options(const struct cmd_struct *cmd, int argc, char *argv[])
 		switch (c) {
 		default:
 			if (cmd->usagestr)
-				usage(cmd->usagestr);
+				usage(cmd);
 		}
 	}
 }
@@ -240,9 +240,9 @@ void usage_command(const struct cmd_struct *cmd, bool full, bool err)
 }
 
 __attribute__((noreturn))
-void usage(const char * const *usagestr)
+void usage(const struct cmd_struct *cmd)
 {
-	usage_command_usagestr(usagestr, NULL, true, true);
+	usage_command_usagestr(cmd->usagestr, NULL, true, true);
 	exit(1);
 }
 
diff --git a/help.h b/help.h
index e642f58d..7468cf8b 100644
--- a/help.h
+++ b/help.h
@@ -56,7 +56,7 @@ struct cmd_struct;
 struct cmd_group;
 
 __attribute__((noreturn))
-void usage(const char * const *usagestr);
+void usage(const struct cmd_struct *cmd);
 void usage_command(const struct cmd_struct *cmd, bool full, bool err);
 void usage_command_group(const struct cmd_group *grp, bool all, bool err);
 void usage_command_group_short(const struct cmd_group *grp);
-- 
2.12.3

