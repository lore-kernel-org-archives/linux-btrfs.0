From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs - use %pU to print fsid
Date: Thu, 31 Mar 2011 12:14:14 -0500
Message-ID: <AANLkTik1TAD6EnVKvWZd_ZnzRqyEwkHAJ+s7J5Gm3nsq@mail.gmail.com>
References: <20110209140531.GA26945@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110209140531.GA26945@kwango.lan.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 9, 2011 at 8:05 AM, Ilya Dryomov <idryomov@gmail.com> wrote=
:
> Get rid of FIXME comment. =A0Uuids from dmesg are now the same as uui=
ds
> given by btrfs-progs.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
> =A0fs/btrfs/volumes.c | =A0 =A08 ++------
> =A01 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2636a05..83b789c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -714,12 +714,8 @@ int btrfs_scan_one_device(const char *path, fmod=
e_t flags, void *holder,
> =A0 =A0 =A0 =A0transid =3D btrfs_super_generation(disk_super);
> =A0 =A0 =A0 =A0if (disk_super->label[0])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "device label %s ", d=
isk_super->label);
> - =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME, make a readl uuid parser */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "device fsid %llx-%llx=
 ",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*(unsigned long long *)d=
isk_super->fsid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*(unsigned long long *)(=
disk_super->fsid + 8));
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "device fsid %pU ", di=
sk_super->fsid);
> =A0 =A0 =A0 =A0printk(KERN_CONT "devid %llu transid %llu %s\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)devid, (unsigned long=
 long)transid, path);
> =A0 =A0 =A0 =A0ret =3D device_list_add(path, disk_super, devid, fs_de=
vices_ret);
> --
> 1.7.2.3
>

I've had this patch in my testing stack for a while now, and it's been
working well.  The fsid now matches the UUID.

It would be nice if the text string lead off with "Btrfs:" or
"btrfs:".  This would be similar to the way other drivers send log
messages, and would make it easier to pick out the Btrfs mount message
from all the other messages.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
