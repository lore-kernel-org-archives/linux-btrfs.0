From: Edward Shishkin <edward@redhat.com>
Subject: Re: [patch 2/2] grub-0.97: btrfs multidevice configuration support
Date: Tue, 03 Nov 2009 01:59:39 +0100
Message-ID: <4AEF807B.6050303@redhat.com>
References: <4ABBED70.30106@redhat.com> <200911022316.39102.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030909010603060709000300"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911022316.39102.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030909010603060709000300
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Content-Transfer-Encoding: 7bit

Johannes Hirte wrote:
> Am Freitag 25 September 2009 00:06:40 schrieb Edward Shishkin:
>   
>
> Hi Edward,
>
> I was pointed to a problem with this patch.
>
> +static u64 scan_grub_devices(struct btrfs_device *dev,
> +                            int (*discerner)(struct btrfs_device **, int),
> +                            int lookup)
> +{
> ...
> +#ifdef SUPPORT_NETBOOT
> +       errnum = ERR_NONE;
> +       if (network_ready &&
> +           !get_diskinfo(NETWORK_DRIVE, &geom)) {
> +               dev->drive = NETWORK_DRIVE;
> +               dev->part = 0;
> +               dev->length = geom.total_sectors;
> +               if (discerner(&dev, lookup)) {
> +                       count++;
> +                       if (lookup)
> +                               goto exit;
> +               }
> +       }
> +#endif /* SUPPORT_NETBOOT */
> + exit:
> +       return count;
> +}
>
> This won't compile since network_ready is undeclared.

Yup, indeed..

>  Why is the btrfs code 
> dealing with network devices at all?
>   

Why not? :)
Well, would you please disable it for now with the attached patch?
 
Thanks,
Edward.

--------------030909010603060709000300
Content-Type: text/plain;
 name="grub-btrfs-multidev-fixup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="grub-btrfs-multidev-fixup.patch"

Disable booting from network devices.

Signed-off-by: Edward Shishkin <edward@redhat.com>
---
 stage2/fsys_btrfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- grub-0.97.orig/stage2/fsys_btrfs.c
+++ grub-0.97/stage2/fsys_btrfs.c
@@ -452,7 +452,7 @@ static u64 scan_grub_devices(struct btrf
 				goto exit;
 		}
 	}
-#ifdef SUPPORT_NETBOOT
+#if 0
 	errnum = ERR_NONE;
 	if (network_ready &&
 	    !get_diskinfo(NETWORK_DRIVE, &geom)) {
@@ -465,7 +465,7 @@ static u64 scan_grub_devices(struct btrf
 				goto exit;
 		}
 	}
-#endif /* SUPPORT_NETBOOT */
+#endif /* 0 */
  exit:
 	return count;
 }

--------------030909010603060709000300--
