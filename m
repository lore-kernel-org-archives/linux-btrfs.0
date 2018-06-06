Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:41094 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbeFFCwr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2018 22:52:47 -0400
Received: by mail-oi0-f67.google.com with SMTP id a141-v6so4057043oii.8
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2018 19:52:46 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Tue, 5 Jun 2018 22:52:45 -0400
Message-ID: <CA+X5Wn7JF2Kr8JnJmL4Vzk4Z3vW8fSqkiQ5akKyrUJfepdEtHw@mail.gmail.com>
Subject: [PATCH] Added verbose option to btrfs device scan
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only works when device(s) not specified.

At verbose level 1, for each registered btrfs filesystem, compactly show fs
uuid, and for each of its devices, the device id, name, and uuid.

At verbose level 2, show everything for the fs and its devices.

Previous behavior of print_all_devices(), which is used by chunk-recover and
super-recover, is unaffected.  (diff doesn't show the patch most optimally.)
---
 cmds-device.c | 20 ++++++++++++---
 utils.c       | 70 ++++++++++++++++++++++++++++++++++++++++++++++-----
 utils.h       |  5 ++--
 3 files changed, 84 insertions(+), 11 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 86459d1b..a2ed71ab 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -254,9 +254,13 @@ static int cmd_device_delete(int argc, char **argv)
 }

 static const char * const cmd_device_scan_usage[] = {
-       "btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
+       "btrfs device scan [([-v] -d|--all-devices)|<device> [<device>...]]",
        "Scan devices for a btrfs filesystem",
        " -d|--all-devices (deprecated)",
+       " -v|--verbose (For each registered btrfs filesystem, show fs
uuid, and for",
+       "               each of its devices, show device id, name, and
uuid.  May",
+       "               be given a second time to show more
information.  Only works",
+       "               when device(s) not specified.)",
        NULL
 };

@@ -265,22 +269,27 @@ static int cmd_device_scan(int argc, char **argv)
        int i;
        int devstart;
        int all = 0;
+       int verbose = 0;
        int ret = 0;

        while (1) {
                int c;
                static const struct option long_options[] = {
                        { "all-devices", no_argument, NULL, 'd'},
+                       { "verbose", no_argument, NULL, 'v'},
                        { NULL, 0, NULL, 0}
                };

-               c = getopt_long(argc, argv, "d", long_options, NULL);
+               c = getopt_long(argc, argv, "dv", long_options, NULL);
                if (c < 0)
                        break;
                switch (c) {
                case 'd':
                        all = 1;
                        break;
+               case 'v':
+                       ++verbose;
+                       break;
                default:
                        usage(cmd_device_scan_usage);
                }
@@ -290,11 +299,16 @@ static int cmd_device_scan(int argc, char **argv)
        if (all && check_argc_max(argc - optind, 1))
                usage(cmd_device_scan_usage);

+       if (devstart < argc) {
+               printf("Verbose mode does not work when device(s) are
specified\n\n");
+               usage(cmd_device_scan_usage);
+       }
+
        if (all || argc - optind == 0) {
                printf("Scanning for Btrfs filesystems\n");
                ret = btrfs_scan_devices();
                error_on(ret, "error %d while scanning", ret);
-               ret = btrfs_register_all_devices();
+               ret = btrfs_register_all_devices(verbose);
                error_on(ret, "there are %d errors while registering
devices", ret);
                goto out;
        }
diff --git a/utils.c b/utils.c
index d81d4980..b5ee08a3 100644
--- a/utils.c
+++ b/utils.c
@@ -1004,7 +1004,7 @@ int btrfs_register_one_device(const char *fname)
  * Register all devices in the fs_uuid list created in the user
  * space. Ensure btrfs_scan_devices() is called before this func.
  */
-int btrfs_register_all_devices(void)
+int btrfs_register_all_devices(int verbose)
 {
        int err = 0;
        int ret = 0;
@@ -1015,7 +1015,15 @@ int btrfs_register_all_devices(void)
        all_uuids = btrfs_scanned_uuids();

        list_for_each_entry(fs_devices, all_uuids, list) {
+               if (verbose == 2)
+
printf("--------------------------------------------------\n");
+               if (verbose)
+                       print_fs_devices_info(fs_devices, verbose);
                list_for_each_entry(device, &fs_devices->devices, dev_list) {
+                       if (verbose == 2)
+                               printf("\n");
+                       if (verbose)
+                               print_device_info(device, "   ", verbose);
                        if (*device->name)
                                err = btrfs_register_one_device(device->name);

@@ -1023,6 +1031,9 @@ int btrfs_register_all_devices(void)
                                ret++;
                }
        }
+       /* Separate possible ERROR summary. (May be unnecessary.) */
+       if (verbose == 2)
+               printf("--------------------------------------------------\n");

        return ret;
 }
@@ -2573,12 +2584,59 @@ unsigned long total_memory(void)
         return si.totalram * si.mem_unit;       /* bytes */
 }

-void print_device_info(struct btrfs_device *device, char *prefix)
+void print_fs_devices_info(struct btrfs_fs_devices *fs_devices, int mode)
 {
-       if (prefix)
+        char fs_uuid[BTRFS_UUID_UNPARSED_SIZE];
+
+        uuid_unparse(fs_devices->fsid, fs_uuid);
+
+        if (mode <= 1) {
+                printf("fs uuid %-36s\n", *fs_uuid ? fs_uuid : "<NULL>");
+        } else {
+               printf("fs uuid: %-36s\n", *fs_uuid ? fs_uuid : "<NULL>");
+               printf("latest_devid: %llu\n", fs_devices->latest_devid);
+               printf("latest_trans: %llu\n", fs_devices->latest_trans);
+               printf("lowest_devid: %llu\n", fs_devices->lowest_devid);
+               printf("latest_bdev: %d\n", fs_devices->latest_bdev);
+               printf("lowest_bdev: %d\n", fs_devices->lowest_bdev);
+               printf("seeding: %d\n", fs_devices->seeding);
+        }
+}
+
+void print_device_info(struct btrfs_device *device, char *prefix, int mode)
+{
+       char dev_uuid[BTRFS_UUID_UNPARSED_SIZE];
+
+       if (prefix && mode <= 1)
                printf("%s", prefix);
-       printf("Device: id = %llu, name = %s\n",
-              device->devid, device->name);
+       if (mode <= 0) {
+               printf("Device: id = %llu, name = %s\n",
+                      device->devid, device->name ? device->name : "<NULL>");
+       } else if (mode == 1) {
+               uuid_unparse(device->uuid, dev_uuid);
+               printf("devid %llu (%s, uuid %-36ss)\n", device->devid,
+                      device->name ? device->name : "<NULL>",
+                      *dev_uuid ? dev_uuid : "<NULL>");
+       } else {
+               uuid_unparse(device->uuid, dev_uuid);
+               printf("devid: %llu\n", device->devid);
+               printf("name: %s\n", device->name ? device->name : "<NULL>");
+               printf("device uuid: %s\n", *dev_uuid ? dev_uuid : "<NULL>");
+               printf("generation (trans): %llu\n", device->generation);
+               printf("total_ios: %llu\n", device->total_ios);
+               printf("fd: %d\n", device->fd);
+               printf("writeable: %d\n", device->writeable);
+               printf("label: %s\n", device->label ? device->label : "<NULL>");
+               printf("total_devs: %llu\n", device->total_devs);
+               printf("super_bytes_used: %llu\n", device->super_bytes_used);
+               printf("total_bytes (size in memory): %llu\n",
+                      device->total_bytes);
+               printf("bytes_used: %llu\n", device->bytes_used);
+               printf("io_align: %lu\n", (unsigned long) device->io_align);
+               printf("io_width: %lu\n", (unsigned long) device->io_width);
+               printf("sector_size: %lu\n", (unsigned long)
device->sector_size);
+               printf("type: %llu\n", device->type);
+       }
 }

 void print_all_devices(struct list_head *devices)
@@ -2587,6 +2645,6 @@ void print_all_devices(struct list_head *devices)

        printf("All Devices:\n");
        list_for_each_entry(dev, devices, dev_list)
-               print_device_info(dev, "\t");
+               print_device_info(dev, "\t", 0);
        printf("\n");
 }
diff --git a/utils.h b/utils.h
index 403de481..9203f52b 100644
--- a/utils.h
+++ b/utils.h
@@ -87,7 +87,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
                      u32 sectorsize);
 int btrfs_scan_for_fsid(int run_ioctls);
 int btrfs_register_one_device(const char *fname);
-int btrfs_register_all_devices(void);
+int btrfs_register_all_devices(int verbose);
 char *canonicalize_dm_name(const char *ptname);
 char *canonicalize_path(const char *path);
 int check_mounted(const char *devicename);
@@ -167,7 +167,8 @@ int prefixcmp(const char *str, const char *prefix);

 unsigned long total_memory(void);

-void print_device_info(struct btrfs_device *device, char *prefix);
+void print_fs_devices_info(struct btrfs_fs_devices *fs_devices, int mode);
+void print_device_info(struct btrfs_device *device, char *prefix, int mode);
 void print_all_devices(struct list_head *devices);

 /*
--
2.17.0
