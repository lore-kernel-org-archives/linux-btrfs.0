From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 2/2] grub-0.97: btrfs multidevice configuration support
Date: Mon, 2 Nov 2009 23:16:38 +0100
Message-ID: <200911022316.39102.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED70.30106@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ABBED70.30106@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag 25 September 2009 00:06:40 schrieb Edward Shishkin:
> 

Hi Edward,

I was pointed to a problem with this patch.

+static u64 scan_grub_devices(struct btrfs_device *dev,
+                            int (*discerner)(struct btrfs_device **, int),
+                            int lookup)
+{
...
+#ifdef SUPPORT_NETBOOT
+       errnum = ERR_NONE;
+       if (network_ready &&
+           !get_diskinfo(NETWORK_DRIVE, &geom)) {
+               dev->drive = NETWORK_DRIVE;
+               dev->part = 0;
+               dev->length = geom.total_sectors;
+               if (discerner(&dev, lookup)) {
+                       count++;
+                       if (lookup)
+                               goto exit;
+               }
+       }
+#endif /* SUPPORT_NETBOOT */
+ exit:
+       return count;
+}

This won't compile since network_ready is undeclared. Why is the btrfs code 
dealing with network devices at all?

regards
  Johannes
