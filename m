From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
 btrfs_ioctl_vol_args
Date: Wed, 21 Jan 2009 10:04:08 -0500
Message-ID: <1232550248.17244.7.camel@think.oraclecorp.com>
References: <20090119125732.GA7424@hack.private>
	 <20090119130337.GA25475@unused.rdu.redhat.com>
	 <20090119131224.GC7424@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090119131224.GC7424@hack.private>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-19 at 21:12 +0800, Am=C3=A9rico Wang wrote:
> On Mon, Jan 19, 2009 at 08:03:37AM -0500, Josef Bacik wrote:
> >On Mon, Jan 19, 2009 at 08:57:32PM +0800, Am=C3=A9rico Wang wrote:
> >>=20
> >> I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
> >> it also looks that this one is more proper.
> >>=20
> >> Kill BTRFS_PATH_NAME_MAX since no one will use it.
> >>=20
> >
> >Nope, BTRFS_PATH_NAME_MAX is specifically used for the ioctl stuff, =
makes the
> >arguments 4k aligned, this patch is incorrect.  Thanks,
>=20
> Ok, then what is BTRFS_VOL_NAME_MAX? :)

Right now it is only used in the progs.  The disk format doesn't really
have a max there, it is just to keep names usable.  But, we should add =
a
check in the kernel ioctl side, are you interested in sending a patch
for it?

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
