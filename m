Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33927 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaBOUa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 15:30:57 -0500
Date: Sat, 15 Feb 2014 20:30:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix 32/64-bit problem with
 BTRFS_SET_RECEIVED_SUBVOL ioctl
Message-ID: <20140215203033.GE3351@carfax.org.uk>
References: <1388944527-16041-1-git-send-email-hugo@carfax.org.uk>
 <20140105182611.GA15634@carfax.org.uk>
 <20140106085044.GB15634@carfax.org.uk>
 <CAOcd+r2v7v9Gee_bp_uEY=7cJj6NWsa8ORx5PzCeyASwtLDpsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
In-Reply-To: <CAOcd+r2v7v9Gee_bp_uEY=7cJj6NWsa8ORx5PzCeyASwtLDpsQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 15, 2014 at 09:42:30PM +0200, Alex Lyakas wrote:
> Hello Hugo,
> 
> Is this issue specific to the receive ioctl?

   Yes. Everything else I've tried has worked perfectly on that test
system. The issue is not pointer size (which is, I think, your
thunking idea below), but structure alignment.

> Because what you are describing applies to any user-kernel ioctl-based
> interface, when you compile the user-space as 32-bit, which the kernel
> space has been compiled as 64-bit. For that purpose, I believe, there
> exists the "compat_ioctl" callback. It's implementation should do
> "thunking", i.e., treat the user-space structure as if it were
> compiled for 32-bit, and unpack it properly.
> 
> Today, however, btrfs supplies the same callback both for
> "unlocked_ioctl" and "compat_ioctl". So we should see the same problem
> with all ioctls, if I am not missing anything.

   As far as I can see, the other ioctls are using structures which
end up being aligned to 8-byte boundaries regardless of the bitness of
the compiler target. Also, we don't tend to pass pointers in the btrfs
ioctls, so we don't have that problem.

   Hugo.

> On Mon, Jan 6, 2014 at 10:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sun, Jan 05, 2014 at 06:26:11PM +0000, Hugo Mills wrote:
> >> On Sun, Jan 05, 2014 at 05:55:27PM +0000, Hugo Mills wrote:
> >> > The structure for BTRFS_SET_RECEIVED_IOCTL packs differently on 32-bit
> >> > and 64-bit systems. This means that it is impossible to use btrfs
> >> > receive on a system with a 64-bit kernel and 32-bit userspace, because
> >> > the structure size (and hence the ioctl number) is different.
> >> >
> >> > This patch adds a compatibility structure and ioctl to deal with the
> >> > above case.
> >>
> >>    Oops, forgot to mention -- this has been compile tested, but not
> >> actually run yet. The machine in question is several miles away and is
> >> a production machine (it's my work desktop, and I can't afford much
> >> downtime on it).
> >
> >    ... And it doesn't even compile properly, now I come to build a
> > .deb. I'm still interested in comments about the general approach, but
> > the specific patch is a load of balls.
> >
> >    Hugo.
> >
> >>    Hugo.
> >>
> >> > Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> >> > ---
> >> >  fs/btrfs/ioctl.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >> >  1 file changed, 87 insertions(+), 8 deletions(-)
> >> >
> >> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> >> > index 21da576..e186439 100644
> >> > --- a/fs/btrfs/ioctl.c
> >> > +++ b/fs/btrfs/ioctl.c
> >> > @@ -57,6 +57,32 @@
> >> >  #include "send.h"
> >> >  #include "dev-replace.h"
> >> >
> >> > +#ifdef CONFIG_64BIT
> >> > +/* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
> >> > + * structures are incorrect, as the timespec structure from userspace
> >> > + * is 4 bytes too small. We define these alternatives here to teach
> >> > + * the kernel about the 32-bit struct packing.
> >> > + */
> >> > +struct btrfs_ioctl_timespec {
> >> > +   __u64 sec;
> >> > +   __u32 nsec;
> >> > +} ((__packed__));
> >> > +
> >> > +struct btrfs_ioctl_received_subvol_args {
> >> > +   char    uuid[BTRFS_UUID_SIZE];  /* in */
> >> > +   __u64   stransid;               /* in */
> >> > +   __u64   rtransid;               /* out */
> >> > +   struct btrfs_ioctl_timespec stime; /* in */
> >> > +   struct btrfs_ioctl_timespec rtime; /* out */
> >> > +   __u64   flags;                  /* in */
> >> > +   __u64   reserved[16];           /* in */
> >> > +} ((__packed__));
> >> > +#endif
> >> > +
> >> > +#define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
> >> > +                           struct btrfs_ioctl_received_subvol_args_32)
> >> > +
> >> > +
> >> >  static int btrfs_clone(struct inode *src, struct inode *inode,
> >> >                    u64 off, u64 olen, u64 olen_aligned, u64 destoff);
> >> >
> >> > @@ -4313,10 +4339,69 @@ static long btrfs_ioctl_quota_rescan_wait(struct file *file, void __user *arg)
> >> >     return btrfs_qgroup_wait_for_completion(root->fs_info);
> >> >  }
> >> >
> >> > +#ifdef CONFIG_64BIT
> >> > +static long btrfs_ioctl_set_received_subvol_32(struct file *file,
> >> > +                                           void __user *arg)
> >> > +{
> >> > +   struct btrfs_ioctl_received_subvol_args_32 *args32 = NULL;
> >> > +   struct btrfs_ioctl_received_subvol_args *args64 = NULL;
> >> > +   int ret = 0;
> >> > +
> >> > +   args32 = memdup_user(arg, sizeof(*args32));
> >> > +   if (IS_ERR(args32)) {
> >> > +           ret = PTR_ERR(args32);
> >> > +           args32 = NULL;
> >> > +           goto out;
> >> > +   }
> >> > +
> >> > +   args64 = malloc(sizeof(*args64));
> >> > +   if (IS_ERR(args64)) {
> >> > +           ret = PTR_ERR(args64);
> >> > +           args64 = NULL;
> >> > +           goto out;
> >> > +   }
> >> > +
> >> > +   memcpy(args64->uuid, args32->uuid, BTRFS_UUID_SIZE);
> >> > +   args64->stransid = args32->stransid;
> >> > +   args64->rtransid = args32->rtransid;
> >> > +   args64->stime.sec = args32->stime.sec;
> >> > +   args64->stime.nsec = args32->stime.nsec;
> >> > +   args64->rtime.sec = args32->rtime.sec;
> >> > +   args64->rtime.nsec = args32->rtime.nsec;
> >> > +   args64->flags = args32->flags;
> >> > +
> >> > +   ret = _btrfs_ioctl_set_received_subvol(file, args64);
> >> > +
> >> > +out:
> >> > +   kfree(args32);
> >> > +   kfree(args64);
> >> > +   return ret;
> >> > +}
> >> > +#endif
> >> > +
> >> >  static long btrfs_ioctl_set_received_subvol(struct file *file,
> >> >                                         void __user *arg)
> >> >  {
> >> >     struct btrfs_ioctl_received_subvol_args *sa = NULL;
> >> > +   int ret = 0;
> >> > +
> >> > +   sa = memdup_user(arg, sizeof(*sa));
> >> > +   if (IS_ERR(sa)) {
> >> > +           ret = PTR_ERR(sa);
> >> > +           sa = NULL;
> >> > +           goto out;
> >> > +   }
> >> > +
> >> > +   ret = _btrfs_ioctl_set_received_subvol(file, sa);
> >> > +
> >> > +out:
> >> > +   kfree(sa);
> >> > +   return ret;
> >> > +}
> >> > +
> >> > +static long _btrfs_ioctl_set_received_subvol(struct file *file,
> >> > +                                       struct btrfs_ioctl_received_subvol_args *sa)
> >> > +{
> >> >     struct inode *inode = file_inode(file);
> >> >     struct btrfs_root *root = BTRFS_I(inode)->root;
> >> >     struct btrfs_root_item *root_item = &root->root_item;
> >> > @@ -4346,13 +4431,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
> >> >             goto out;
> >> >     }
> >> >
> >> > -   sa = memdup_user(arg, sizeof(*sa));
> >> > -   if (IS_ERR(sa)) {
> >> > -           ret = PTR_ERR(sa);
> >> > -           sa = NULL;
> >> > -           goto out;
> >> > -   }
> >> > -
> >> >     /*
> >> >      * 1 - root item
> >> >      * 2 - uuid items (received uuid + subvol uuid)
> >> > @@ -4411,7 +4489,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
> >> >             ret = -EFAULT;
> >> >
> >> >  out:
> >> > -   kfree(sa);
> >> >     up_write(&root->fs_info->subvol_sem);
> >> >     mnt_drop_write_file(file);
> >> >     return ret;
> >> > @@ -4572,6 +4649,8 @@ long btrfs_ioctl(struct file *file, unsigned int
> >> >             return btrfs_ioctl_balance_progress(root, argp);
> >> >     case BTRFS_IOC_SET_RECEIVED_SUBVOL:
> >> >             return btrfs_ioctl_set_received_subvol(file, argp);
> >> > +   case BTRFS_IOC_SET_RECEIVED_SUBVOL_32:
> >> > +           return btrfs_ioctl_set_received_subvol_32(file, argp);
> >> >     case BTRFS_IOC_SEND:
> >> >             return btrfs_ioctl_send(file, argp);
> >> >     case BTRFS_IOC_GET_DEV_STATS:
> >>
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- That's not rain,  that's a lake with slots in it. ---        

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUv/OaVheFHXiqx3kAQKQbw//YHYpfYPNBnxsepnpto6HmanNfqfNwv0E
2fCqAL/oFXl/MhKtxv8Nwq+DxdFemXHk+dlf/ykQgVVmikyj2ycPkPcihWAvoFhb
i5vpyLwp2YZ+cttlrKDfvSF6J6zq7fOvMAnBCegCaHWWG6YFCDtgOj/EMU21A+3K
f/xiSUvzkW6AKWjZCOf44/okrSe2w3W2WpKStG5NHV2xt1ERcsOrLO0wumx3Vf7I
cNSdBFzLLs0omkV6GPqm6Lu0NCLXMHcg16dK6a7pv90aikgttrl21uZ64dv2cAvq
WuoS1jyZJEmTkqL09ImXmV13+q7OsJJvuNhNGvk0Lb06SRfufgDu/G8AEDxvJGkY
xerKV2mrWSfS+mwzWQY1J9ayZK2P0SQ65jhVcNfHrPR80xTjhWsKQvWj5a+7naNo
lp+vvO3lQcV8Xqt9YfhGw5Tn5cz8u7IejJ8orS3l+c8gMz86EPVuSPbQzt9fu481
x7noK7oucfrvNZb83DiPSZIcdyf40bheYg0qw+l+IpWV7MXwsGXgb5qVAIj1k9mb
SQxQhl+oSDs3u4JbWubeI5K8s55HCDVSws9/xbNEDfzExQDzbQUgmXfkcsVkOHqZ
4CHfIkCk8YAYISaXV/2rW/0kGkHp74l2m3beMMmJbkfJ7MVUYViVovyLnsVG7gPS
9Fy7PErt2fo=
=yVrc
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
