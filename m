From: Chris Mason <chris.mason@oracle.com>
Subject: Re: volume broken? btrfsck fails
Date: Sun, 11 Jul 2010 20:50:46 -0400
Message-ID: <20100712005046.GO3032@think>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
 <loom.20100701T144515-658@post.gmane.org>
 <20100707001930.GI15984@think>
 <AANLkTilfqxC8ds3F3ee53eJsigGWgksLbcSFVxVd4rRV@mail.gmail.com>
 <AANLkTilg_twnCqQVjhd-FxCL1UB7c75ewbgDoGfDS7GZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Daniel Kozlowski <dan.kozlowski@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilg_twnCqQVjhd-FxCL1UB7c75ewbgDoGfDS7GZ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 07, 2010 at 10:39:48PM -0400, Daniel Kozlowski wrote:
> >> Looks like we're looping on a single block. =A0What happens when y=
ou
> >> dmesg -n1 to cut down on the console traffic?
> >>
> > Nothing changes I still have endless repeats of
> >
> > parent transid verify failed on 1682586464256 wanted 285114 found 1=
1257
> >
> >> If that doesn't help we can change it to spit a stack trace to fig=
ure
> >> out where the looping is happening. =A0We should be erroring out i=
nstead
> >> of hitting it over and over again.
> >
> > In my kernel noviceness i tried attaching gdb to the btrfs-endio-me=
t,
> > however apparently you can't attach gdb to a kernel thread like tha=
t
> > If you could assist me in obtaining a call trace I will gladly atte=
mpt
> > to resolve the matter.
>=20
> Ok I had some free time and decided to excersice my googlefoo and cam=
e
> up with this trace
>=20
> parent transid verify failed on 3241193205760 wanted 285287 found 281=
382
> Pid: 2163, comm: mount Not tainted 2.6.35-0.23.rc3.git6.fc14.x86_64 #=
1
> Call Trace:
>  [<ffffffffa047c376>] verify_parent_transid+0xb7/0xfe [btrfs]
>  [<ffffffffa047c4f2>] btrfs_buffer_uptodate+0x49/0x59 [btrfs]
>  [<ffffffffa04686a2>] read_block_for_search+0x8f/0x289 [btrfs]
>  [<ffffffffa046d554>] btrfs_search_slot+0x3ae/0x513 [btrfs]
>  [<ffffffffa0470ece>] btrfs_read_block_groups+0x73/0x526 [btrfs]
>  [<ffffffff8149b0a3>] ? _raw_spin_unlock+0x2b/0x2f
>  [<ffffffffa0469f56>] ? btrfs_root_node+0x2a/0x32 [btrfs]
>  [<ffffffffa047d287>] ? find_and_setup_root+0xab/0xbc [btrfs]
>  [<ffffffffa04800eb>] open_ctree+0xf19/0x143a [btrfs]
>  [<ffffffffa0467960>] btrfs_get_sb+0x1ce/0x40b [btrfs]
>  [<ffffffff810e9cfd>] ? free_pages+0x49/0x4e
>  [<ffffffff8112c9f9>] vfs_kern_mount+0xbd/0x19b
>  [<ffffffff8112cb3f>] do_kern_mount+0x4d/0xed
>  [<ffffffff81143742>] do_mount+0x776/0x7ed
>  [<ffffffff81143841>] sys_mount+0x88/0xc2
>  [<ffffffff81009c32>] system_call_fastpath+0x16/0x1b


Ok, so we're never getting out of mount.  A recent change to
read_block_for_search is causing this problem.  We're looping over and
over again because it is returning -EAGAIN instead of -EIO.

Thanks for nailing this trace down, I'll get a fix in for the looping.
I'm afraid it won't bring back the filesystem though, you'll end up
failing in mount.  Would you like some helping copying the data off?

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
