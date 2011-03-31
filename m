From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH] Btrfs - use %pU to print fsid
Date: Fri, 1 Apr 2011 01:21:26 +0300
Message-ID: <20110331222126.GA2630@kwango.lan.net>
References: <20110209140531.GA26945@kwango.lan.net> <AANLkTik1TAD6EnVKvWZd_ZnzRqyEwkHAJ+s7J5Gm3nsq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik1TAD6EnVKvWZd_ZnzRqyEwkHAJ+s7J5Gm3nsq@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2011 at 12:14:14PM -0500, Mitch Harder wrote:
> On Wed, Feb 9, 2011 at 8:05 AM, Ilya Dryomov <idryomov@gmail.com> wro=
te:
> > Get rid of FIXME comment. =C2=A0Uuids from dmesg are now the same a=
s uuids
> > given by btrfs-progs.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> > =C2=A0fs/btrfs/volumes.c | =C2=A0 =C2=A08 ++------
> > =C2=A01 files changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 2636a05..83b789c 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -714,12 +714,8 @@ int btrfs_scan_one_device(const char *path, fm=
ode_t flags, void *holder,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0transid =3D btrfs_super_generation(disk_=
super);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (disk_super->label[0])
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_=
INFO "device label %s ", disk_super->label);
> > - =C2=A0 =C2=A0 =C2=A0 else {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* FIXME, make a=
 readl uuid parser */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_INFO=
 "device fsid %llx-%llx ",
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0*(unsigned long long *)disk_super->fsid,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0*(unsigned long long *)(disk_super->fsid + 8));
> > - =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_INFO=
 "device fsid %pU ", disk_super->fsid);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_CONT "devid %llu transid %ll=
u %s\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (unsigned long lon=
g)devid, (unsigned long long)transid, path);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D device_list_add(path, disk_super=
, devid, fs_devices_ret);
> > --
> > 1.7.2.3
> >
>=20
> I've had this patch in my testing stack for a while now, and it's bee=
n
> working well.  The fsid now matches the UUID.

Chris for some reason didn't add it to the pull request, probably
because it's minor.

> It would be nice if the text string lead off with "Btrfs:" or
> "btrfs:".  This would be similar to the way other drivers send log
> messages, and would make it easier to pick out the Btrfs mount messag=
e
> from all the other messages.

Currently there is a mix: some of the messages are printed with
"btrfs:", others with "btrfs", most of the messages informing about
abnormal conditions are printed w/o any prefix.  I can resend this one
with "btrfs:" prefix, but I think some kind of decision needed, so this
whole thing can be fixed in one commit.

Thanks,

		Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
