Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49293 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaAFIuq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 03:50:46 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1W05tT-0006CG-JP
	for linux-btrfs@vger.kernel.org; Mon, 06 Jan 2014 08:50:44 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.82)
	(envelope-from <hrm@carfax.org.uk>)
	id 1W05tU-00034o-Ih
	for linux-btrfs@vger.kernel.org; Mon, 06 Jan 2014 08:50:44 +0000
Date: Mon, 6 Jan 2014 08:50:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix 32/64-bit problem with
 BTRFS_SET_RECEIVED_SUBVOL ioctl
Message-ID: <20140106085044.GB15634@carfax.org.uk>
References: <1388944527-16041-1-git-send-email-hugo@carfax.org.uk>
 <20140105182611.GA15634@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
In-Reply-To: <20140105182611.GA15634@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 05, 2014 at 06:26:11PM +0000, Hugo Mills wrote:
> On Sun, Jan 05, 2014 at 05:55:27PM +0000, Hugo Mills wrote:
> > The structure for BTRFS_SET_RECEIVED_IOCTL packs differently on 32-bit
> > and 64-bit systems. This means that it is impossible to use btrfs
> > receive on a system with a 64-bit kernel and 32-bit userspace, because
> > the structure size (and hence the ioctl number) is different.
> > 
> > This patch adds a compatibility structure and ioctl to deal with the
> > above case.
> 
>    Oops, forgot to mention -- this has been compile tested, but not
> actually run yet. The machine in question is several miles away and is
> a production machine (it's my work desktop, and I can't afford much
> downtime on it).

   ... And it doesn't even compile properly, now I come to build a
.deb. I'm still interested in comments about the general approach, but
the specific patch is a load of balls.

   Hugo.

>    Hugo.
> 
> > Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> > ---
> >  fs/btrfs/ioctl.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 87 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 21da576..e186439 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -57,6 +57,32 @@
> >  #include "send.h"
> >  #include "dev-replace.h"
> >  
> > +#ifdef CONFIG_64BIT
> > +/* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
> > + * structures are incorrect, as the timespec structure from userspace
> > + * is 4 bytes too small. We define these alternatives here to teach
> > + * the kernel about the 32-bit struct packing.
> > + */
> > +struct btrfs_ioctl_timespec {
> > +	__u64 sec;
> > +	__u32 nsec;
> > +} ((__packed__));
> > +
> > +struct btrfs_ioctl_received_subvol_args {
> > +	char	uuid[BTRFS_UUID_SIZE];	/* in */
> > +	__u64	stransid;		/* in */
> > +	__u64	rtransid;		/* out */
> > +	struct btrfs_ioctl_timespec stime; /* in */
> > +	struct btrfs_ioctl_timespec rtime; /* out */
> > +	__u64	flags;			/* in */
> > +	__u64	reserved[16];		/* in */
> > +} ((__packed__));
> > +#endif
> > +
> > +#define BTRFS_IOC_SET_RECEIVED_SUBVOL_32 _IOWR(BTRFS_IOCTL_MAGIC, 37, \
> > +				struct btrfs_ioctl_received_subvol_args_32)
> > +
> > +
> >  static int btrfs_clone(struct inode *src, struct inode *inode,
> >  		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
> >  
> > @@ -4313,10 +4339,69 @@ static long btrfs_ioctl_quota_rescan_wait(struct file *file, void __user *arg)
> >  	return btrfs_qgroup_wait_for_completion(root->fs_info);
> >  }
> >  
> > +#ifdef CONFIG_64BIT
> > +static long btrfs_ioctl_set_received_subvol_32(struct file *file,
> > +						void __user *arg)
> > +{
> > +	struct btrfs_ioctl_received_subvol_args_32 *args32 = NULL;
> > +	struct btrfs_ioctl_received_subvol_args *args64 = NULL;
> > +	int ret = 0;
> > +
> > +	args32 = memdup_user(arg, sizeof(*args32));
> > +	if (IS_ERR(args32)) {
> > +		ret = PTR_ERR(args32);
> > +		args32 = NULL;
> > +		goto out;
> > +	}
> > +
> > +	args64 = malloc(sizeof(*args64));
> > +	if (IS_ERR(args64)) {
> > +		ret = PTR_ERR(args64);
> > +		args64 = NULL;
> > +		goto out;
> > +	}
> > +
> > +	memcpy(args64->uuid, args32->uuid, BTRFS_UUID_SIZE);
> > +	args64->stransid = args32->stransid;
> > +	args64->rtransid = args32->rtransid;
> > +	args64->stime.sec = args32->stime.sec;
> > +	args64->stime.nsec = args32->stime.nsec;
> > +	args64->rtime.sec = args32->rtime.sec;
> > +	args64->rtime.nsec = args32->rtime.nsec;
> > +	args64->flags = args32->flags;
> > +
> > +	ret = _btrfs_ioctl_set_received_subvol(file, args64);
> > +
> > +out:
> > +	kfree(args32);
> > +	kfree(args64);
> > +	return ret;
> > +}
> > +#endif
> > +
> >  static long btrfs_ioctl_set_received_subvol(struct file *file,
> >  					    void __user *arg)
> >  {
> >  	struct btrfs_ioctl_received_subvol_args *sa = NULL;
> > +	int ret = 0;
> > +
> > +	sa = memdup_user(arg, sizeof(*sa));
> > +	if (IS_ERR(sa)) {
> > +		ret = PTR_ERR(sa);
> > +		sa = NULL;
> > +		goto out;
> > +	}
> > +
> > +	ret = _btrfs_ioctl_set_received_subvol(file, sa);
> > +
> > +out:
> > +	kfree(sa);
> > +	return ret;
> > +}
> > +
> > +static long _btrfs_ioctl_set_received_subvol(struct file *file,
> > +					    struct btrfs_ioctl_received_subvol_args *sa)
> > +{
> >  	struct inode *inode = file_inode(file);
> >  	struct btrfs_root *root = BTRFS_I(inode)->root;
> >  	struct btrfs_root_item *root_item = &root->root_item;
> > @@ -4346,13 +4431,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
> >  		goto out;
> >  	}
> >  
> > -	sa = memdup_user(arg, sizeof(*sa));
> > -	if (IS_ERR(sa)) {
> > -		ret = PTR_ERR(sa);
> > -		sa = NULL;
> > -		goto out;
> > -	}
> > -
> >  	/*
> >  	 * 1 - root item
> >  	 * 2 - uuid items (received uuid + subvol uuid)
> > @@ -4411,7 +4489,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
> >  		ret = -EFAULT;
> >  
> >  out:
> > -	kfree(sa);
> >  	up_write(&root->fs_info->subvol_sem);
> >  	mnt_drop_write_file(file);
> >  	return ret;
> > @@ -4572,6 +4649,8 @@ long btrfs_ioctl(struct file *file, unsigned int
> >  		return btrfs_ioctl_balance_progress(root, argp);
> >  	case BTRFS_IOC_SET_RECEIVED_SUBVOL:
> >  		return btrfs_ioctl_set_received_subvol(file, argp);
> > +	case BTRFS_IOC_SET_RECEIVED_SUBVOL_32:
> > +		return btrfs_ioctl_set_received_subvol_32(file, argp);
> >  	case BTRFS_IOC_SEND:
> >  		return btrfs_ioctl_send(file, argp);
> >  	case BTRFS_IOC_GET_DEV_STATS:
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUspuZFheFHXiqx3kAQKLIhAAsOxs/6pw7LKJ3ArLfKeTXTxlrI2RV28A
QQnWux4ZjnAGi+MTi5I0OK/J2aMYX3F6hVcscE3uYd+2F3EoiIO2gQtwCdm1gLYv
Ran0rGtGkb911q1BQ9hfxmGDob4umT8A+S9TC6rpyxoUUE9IxIOkQFW2rANKEoSC
jLg5QGTw2nh/7q/r5wDnMPUSFXa8Pp9w9sM4oXH+c2WRWd8KIKIKgJCzLDvuVASd
XltEBb8X/I547OSxTFYG2TnjXpYSF+Sa+5F5nFjxOVv/6SsZOCcmeuneuyqsGnfH
jPC+W3Q5tUBsSC9G8+QACwNtVw9kzVTkub88N1bB4d8F6gVq2So2oUngH9v57UtT
u+VMh2F0MdUNo3s5jIc1Prh4lm/NPzn/DlZJ3Fozl0Sm65hKW25tOjjSaVittOLn
B5QlKrF5w0w8NbIQVLSdr7UUxKMyIGyARmb50VWok0XXtO2seINNX6SrLz7yZWZW
gRmcsMV+Bz5syXLfgtBct+PRoivAGOBo/wNfN65T8rzRYPoJdAMTmwqva4PcIaoY
XUo8mznbBwKAajauKgspfqyzMw1MXYKp5YNprR+kHmwRQ+kCjB9yokuYGWQJXBbb
yu+DK4t5XpghdhAJlVNZ5bRZwwilLVy5HaTvsPlabWaGBRUSomCrqymJf/3hqicf
GVHZBoYZk90=
=xUOX
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
