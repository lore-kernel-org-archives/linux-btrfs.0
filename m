From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] Btrfs-progs: added btrfs filesystem label [label] [path]
 support V2
Date: Thu, 01 Sep 2011 19:52:54 +0800
Message-ID: <4E5F7216.7040909@oracle.com>
References: <4E5F47C7.3030803@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Hugo Mills <hugo@carfax.org.uk>, chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5F47C7.3030803@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Revise the patch according to kernel side change.

  Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
  btrfs.c      |    7 +++----
  btrfs_cmds.c |   34 ++++++++++++++++++++++++++++++++++
  btrfs_cmds.h |    1 +
  ctree.h      |    4 ++++
  ioctl.h      |    2 ++
  mkfs.c       |   19 -------------------
  utils.c      |   18 ++++++++++++++++++
  utils.h      |    1 +
  8 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..6d414f1 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -108,11 +108,10 @@ static struct Command commands[] = {
        "device delete", "<dev> [<dev>..] <path>\n"
          "Remove a device from a filesystem."
      },
-    /* coming soon
-    { 2, "filesystem label", "<label> <path>\n"
+    { do_set_label, 2,
+      "filesystem label", "<label> <path>\n"
          "Set the label of a filesystem"
-    }
-    */
+    },
      { 0, 0 , 0 }
  };

diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..2a879c0 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -834,6 +834,40 @@ int do_set_default_subvol(int nargs, char **argv)
      return 0;
  }

+int do_set_label(int nargs, char **argv)
+{
+    int    fd, ret;
+    char    *path = argv[2];
+    char    *label = parse_label(argv[1]);
+    size_t    len = strlen(label);
+    struct    btrfs_ioctl_fs_label_args label_args;
+
+    if (len == 0 || len >= BTRFS_LABEL_SIZE) {
+        fprintf(stderr, "ERROR: label length too long ('%s')\n",
+            label);
+        free(label);
+        return 14;
+    }
+
+    fd = open_file_or_dir(path);
+    if (fd < 0) {
+        free(label);
+        fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+        return 12;
+    }
+
+    strcpy(label_args.label, label);
+    ret = ioctl(fd, BTRFS_IOC_FS_SETLABEL, &label_args);
+    close(fd);
+    free(label);
+    if(ret < 0) {
+        fprintf(stderr, "ERROR: unable to set a new label\n");
+        return 30;
+    }
+
+    return 0;
+}
+
  int do_df_filesystem(int nargs, char **argv)
  {
      struct btrfs_ioctl_space_args *sargs;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..29ded22 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -32,3 +32,4 @@ int list_subvols(int fd);
  int do_df_filesystem(int nargs, char **argv);
  int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
  int do_find_newer(int argc, char **argv);
+int do_set_label(int argc, char **argv);
diff --git a/ctree.h b/ctree.h
index b79e238..745879b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -345,6 +345,10 @@ struct btrfs_super_block {
      u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
  } __attribute__ ((__packed__));

+struct btrfs_ioctl_fs_label_args {
+    char label[BTRFS_LABEL_SIZE];
+};
+
  /*
   * Compat flags that we support.  If any incompat flags are set other 
than the
   * ones specified below then we will fail to mount
diff --git a/ioctl.h b/ioctl.h
index 776d7a9..98acd63 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -140,6 +140,8 @@ struct btrfs_ioctl_space_args {
                     struct btrfs_ioctl_vol_args)
  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
                     struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_FS_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 5, \
+                   struct btrfs_ioctl_fs_label_args)
  /* trans start and trans end are dangerous, and only for
   * use by applications that know how to avoid the
   * resulting deadlocks
diff --git a/mkfs.c b/mkfs.c
index 1598aae..93c1636 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -303,25 +303,6 @@ static u64 parse_profile(char *s)
      return 0;
  }

-static char *parse_label(char *input)
-{
-    int i;
-    int len = strlen(input);
-
-    if (len >= BTRFS_LABEL_SIZE) {
-        fprintf(stderr, "Label %s is too long (max %d)\n", input,
-            BTRFS_LABEL_SIZE - 1);
-        exit(1);
-    }
-    for (i = 0; i < len; i++) {
-        if (input[i] == '/' || input[i] == '\\') {
-            fprintf(stderr, "invalid label %s\n", input);
-            exit(1);
-        }
-    }
-    return strdup(input);
-}
-
  static struct option long_options[] = {
      { "alloc-start", 1, NULL, 'A'},
      { "byte-count", 1, NULL, 'b' },
diff --git a/utils.c b/utils.c
index fd894f3..5d77503 100644
--- a/utils.c
+++ b/utils.c
@@ -993,3 +993,21 @@ char *pretty_sizes(u64 size)
      return pretty;
  }

+char *parse_label(const char *input)
+{
+    int i;
+    int len = strlen(input);
+
+    if (len >= BTRFS_LABEL_SIZE) {
+        fprintf(stderr, "Label %s is too long (max %d)\n", input,
+            BTRFS_LABEL_SIZE - 1);
+        exit(1);
+    }
+    for (i = 0; i < len; i++) {
+        if (input[i] == '/' || input[i] == '\\') {
+            fprintf(stderr, "invalid label %s\n", input);
+            exit(1);
+        }
+    }
+    return strdup(input);
+}
diff --git a/utils.h b/utils.h
index 9dce5b0..9212a75 100644
--- a/utils.h
+++ b/utils.h
@@ -40,4 +40,5 @@ int check_mounted(const char *devicename);
  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
                   int super_offset);
  char *pretty_sizes(u64 size);
+char *parse_label(const char *);
  #endif
-- 
1.7.4.1

On 09/01/2011 04:52 PM, Jeff Liu wrote:
> Hello,
>
> This patch make use of the new ioctl(2) to set Btrfs label via `btrfs 
> filesystem label` command.
>
>  Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
>  btrfs.c      |    7 +++----
>  btrfs_cmds.c |   27 +++++++++++++++++++++++++++
>  btrfs_cmds.h |    1 +
>  ctree.h      |    6 ++++++
>  ioctl.h      |    2 ++
>  mkfs.c       |   19 -------------------
>  utils.c      |   18 ++++++++++++++++++
>  utils.h      |    1 +
>  8 files changed, 58 insertions(+), 23 deletions(-)
>
> diff --git a/btrfs.c b/btrfs.c
> index 46314cf..6d414f1 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -108,11 +108,10 @@ static struct Command commands[] = {
>        "device delete", "<dev> [<dev>..] <path>\n"
>          "Remove a device from a filesystem."
>      },
> -    /* coming soon
> -    { 2, "filesystem label", "<label> <path>\n"
> +    { do_set_label, 2,
> +      "filesystem label", "<label> <path>\n"
>          "Set the label of a filesystem"
> -    }
> -    */
> +    },
>      { 0, 0 , 0 }
>  };
>
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 8031c58..8d2b8e1 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -834,6 +834,33 @@ int do_set_default_subvol(int nargs, char **argv)
>      return 0;
>  }
>
> +int do_set_label(int nargs, char **argv)
> +{
> +    int    fd, ret = 0;
> +    char    *path = argv[2];
> +    char    *label = parse_label(argv[1]);
> +    size_t    len = strlen(label);
> +    struct    btrfs_ioctl_fs_label_args label_args;
> +
> +    fd = open_file_or_dir(path);
> +    if (fd < 0) {
> +        fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +        return 12;
> +    }
> +
> +    label_args.len = len;
> +    snprintf(label_args.label, BTRFS_LABEL_SIZE, "%s", label);
> +    ret = ioctl(fd, BTRFS_IOC_FS_SETLABEL, &label_args);
> +    close(fd);
> +    free(label);
> +    if(ret < 0) {
> +        fprintf(stderr, "ERROR: unable to set a new label\n");
> +        return 30;
> +    }
> +
> +    return 0;
> +}
> +
>  int do_df_filesystem(int nargs, char **argv)
>  {
>      struct btrfs_ioctl_space_args *sargs;
> diff --git a/btrfs_cmds.h b/btrfs_cmds.h
> index 7bde191..29ded22 100644
> --- a/btrfs_cmds.h
> +++ b/btrfs_cmds.h
> @@ -32,3 +32,4 @@ int list_subvols(int fd);
>  int do_df_filesystem(int nargs, char **argv);
>  int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
>  int do_find_newer(int argc, char **argv);
> +int do_set_label(int argc, char **argv);
> diff --git a/ctree.h b/ctree.h
> index b79e238..4924b88 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -345,6 +345,12 @@ struct btrfs_super_block {
>      u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
>  } __attribute__ ((__packed__));
>
> +struct btrfs_ioctl_fs_label_args {
> +    /* label length in bytes */
> +    __u32 len;
> +    char label[BTRFS_LABEL_SIZE];
> +};
> +
>  /*
>   * Compat flags that we support.  If any incompat flags are set other 
> than the
>   * ones specified below then we will fail to mount
> diff --git a/ioctl.h b/ioctl.h
> index 776d7a9..5750f3a 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -169,4 +169,6 @@ struct btrfs_ioctl_space_args {
>  #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
>  #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
>                      struct btrfs_ioctl_space_args)
> +#define BTRFS_IOC_FS_SETLABEL _IOW(BTRFS_IOCTL_MAGIC, 32, \
> +                   struct btrfs_ioctl_fs_label_args)
>  #endif
> diff --git a/mkfs.c b/mkfs.c
> index 1598aae..93c1636 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -303,25 +303,6 @@ static u64 parse_profile(char *s)
>      return 0;
>  }
>
> -static char *parse_label(char *input)
> -{
> -    int i;
> -    int len = strlen(input);
> -
> -    if (len >= BTRFS_LABEL_SIZE) {
> -        fprintf(stderr, "Label %s is too long (max %d)\n", input,
> -            BTRFS_LABEL_SIZE - 1);
> -        exit(1);
> -    }
> -    for (i = 0; i < len; i++) {
> -        if (input[i] == '/' || input[i] == '\\') {
> -            fprintf(stderr, "invalid label %s\n", input);
> -            exit(1);
> -        }
> -    }
> -    return strdup(input);
> -}
> -
>  static struct option long_options[] = {
>      { "alloc-start", 1, NULL, 'A'},
>      { "byte-count", 1, NULL, 'b' },
> diff --git a/utils.c b/utils.c
> index fd894f3..5d77503 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -993,3 +993,21 @@ char *pretty_sizes(u64 size)
>      return pretty;
>  }
>
> +char *parse_label(const char *input)
> +{
> +    int i;
> +    int len = strlen(input);
> +
> +    if (len >= BTRFS_LABEL_SIZE) {
> +        fprintf(stderr, "Label %s is too long (max %d)\n", input,
> +            BTRFS_LABEL_SIZE - 1);
> +        exit(1);
> +    }
> +    for (i = 0; i < len; i++) {
> +        if (input[i] == '/' || input[i] == '\\') {
> +            fprintf(stderr, "invalid label %s\n", input);
> +            exit(1);
> +        }
> +    }
> +    return strdup(input);
> +}
> diff --git a/utils.h b/utils.h
> index 9dce5b0..9212a75 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -40,4 +40,5 @@ int check_mounted(const char *devicename);
>  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>                   int super_offset);
>  char *pretty_sizes(u64 size);
> +char *parse_label(const char *);
>  #endif

