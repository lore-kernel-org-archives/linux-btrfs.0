Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:45124 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932097AbeFFGam (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 02:30:42 -0400
Received: by mail-oi0-f68.google.com with SMTP id b130-v6so4380335oif.12
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2018 23:30:42 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Wed, 6 Jun 2018 02:30:41 -0400
Message-ID: <CA+X5Wn6h8sot6Z7OQVvehD_T4XxHOiss=gT18s_d6EJPZrUhQA@mail.gmail.com>
Subject: [PATCH] btrfs-progs: btrfs_close_devices(): only fsync() if device->writeable
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Prevent unnecessary error from failing fsync(), if opened read only.

Performed 'grep "writeable = " *.h *.c' to make sure there were no odd
situations where fsync() might still be desired here.  They're all straight-
forward.  The only situation where writeable will be 0 is if btrfs_open_devices
is given flags without O_RDWR.  There is no situation where a writeable volume
temporarily becomes unwriteable, or anything like that.  Given that it's being
opened O_RDWR, there's no reason to attempt fsync().

utils.c

   int btrfs_add_to_fsid() {
      ...
      device->writeable = 1;

volumes.c

   int btrfs_close_devices() {
      ...
      while (!list_empty(&fs_devices->devices)) {
         ...
         // just after the fsync() being patched
267:     device->writeable = 0;
   ...
   int btrfs_open_devices() {
      ...
      list_for_each_entry(device, &fs_devices->devices, dev_list) {
         ...
         if (flags & O_RDWR)
332:        device->writeable = 1

kernel btrfs_close_devices() does not have a corresponding fsync() that I see.

Signed-off-by: James Harvey <jamespharvey20@gmail.com>
---
 volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index c6e34321..36d1bde6 100644
--- a/volumes.c
+++ b/volumes.c
@@ -254,7 +254,7 @@ again:
                device = list_entry(fs_devices->devices.next,
                                    struct btrfs_device, dev_list);
                if (device->fd != -1) {
-                       if (fsync(device->fd) == -1) {
+                       if (device->writeable && fsync(device->fd) == -1) {
                                warning("fsync on device %llu failed: %m",
                                        device->devid);
                                ret = -errno;
--
2.17.0
