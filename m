From: Shawn Stricker <kb1ibt@me.com>
Subject: Re: full btrfs partition,
 became unmountable (+ a solution that thankfully worked for me)
Date: Tue, 25 Jan 2011 23:38:02 -0500
Message-ID: <BC28BE23-1017-456E-9EAA-74A840809085@me.com>
References: <1295981200.29117.19.camel@hestia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: =?iso-8859-1?Q?Cyrille_Ch=E9p=E9lov?= <cyrille@chepelov.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1295981200.29117.19.camel@hestia>
List-ID: <linux-btrfs.vger.kernel.org>

Not sure where you pulled your source from but a fresh checkout of eith=
er master or next of git.kernel.org/pub/scm/linux/kernel/git/mason/btrf=
s-progs-unstable.git does not compile properly.
They both fail with=20

cc1: warnings being treated as errors
disk-io.c: In function =91btrfs_read_dev_super=92:
disk-io.c:937: error: format =91%lu=92 expects type =91long unsigned in=
t=92, but argument 4 has type =91unsigned int=92
disk-io.c:957: error: implicit declaration of function =91uuid_unparse=92

am I patching/compiling from the wrong source or is there something I a=
m missing?
On Jan 25, 2011, at 1:46 PM, Cyrille Ch=E9p=E9lov wrote:

> Hello all,
>=20
> Last Friday, the /var and /home partition on one of my appliances bec=
ame
> full. This should normally not be much of a problem, except that afte=
r
> the incident, I had been unable to mount the partition back again.
>=20
> The appliance runs 2.6.32 as provided by Debian during the last two
> months.=20
> The rescue computer runs 2.6.37; both exhibited the same behaviour at
> mount: an infinite loop-and-abort cycle (I unfortunately did not writ=
e
> down the exact messages, but in a nutshell, there was not enough free
> space to replay the log, so it aborted).
>=20
> After pulling the SD card (yes) to break the loop, I ended up with a
> corrupt file system. Any attempt to mount, debug or fsck (using
> btrfs-tools 0.19+20100601 as shipped by Debian, or compiled from git
> 1b444cd2e6ab8dcafdd) aborted with the following message:
>    btrfs-debug-tree: disk-io.c:741: open_ctree_fd: Assertion `!(!
> tree_root->node)' failed.
>=20
> After much scavenging on the disk image, I finally managed to recover=
,
> using the (dirty) patch attached here. Since apparently other people =
had
> similar issues, I'm posting it in the hope it might be useful.
>=20
>    -- Cyrille
>=20
> PS: Chris, if btrfs-images of "before" and "after" my butcher fix wou=
ld
> be useful to you, just let me know.=20
> <scavenge.patch>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
