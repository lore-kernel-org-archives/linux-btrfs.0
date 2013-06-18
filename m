Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:45015 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3FRMTs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 08:19:48 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so2469876eaj.17
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 05:19:46 -0700 (PDT)
Message-ID: <1371557514.3293.21.camel@ivbl>
Subject: Re: BUG at fs/btrfs/print-tree when trying to mount after a crash
From: Michael Zugelder <michael@zugelder.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <pan$89a8$49bdccdf$48e0ce45$59d9acc9@cox.net>
References: <1371496227.3925.44.camel@ivbl>
	 <pan$89a8$49bdccdf$48e0ce45$59d9acc9@cox.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jun 2013 14:11:54 +0200
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply.

On Tue, 2013-06-18 at 06:04 +0000, Duncan wrote:
[...]
> 1) I had an similar issue some time back that turned out to be a 
> corrupted space-cache.  Try mounting with the "nospace_cache" option.  If 
> that works that's it; mount with the "clear_cache" option to clear the 
> bad cache and perhaps once again with space_cache to turn it back on. 
> (Space-cache is one of the few options that's persistent, but I'm not 
> sure if no-cache is equally persistent, making it a toggle, or if once 
> it's on there's no way to turn it off permanently.)
> 
> The clear_cache option will trigger a cache rebuild, so will take some 
> time on slower devices (you said SSD but didn't say whether it was a slow 
> one or a fast one).  See the mount-options page at the wiki for more.
> 
> https://btrfs.wiki.kernel.org/index.php/Mount_options#Space_cache_control

Tried it out, but still BUGs the same way. I'm using a full-disk backup
on a regular HDD, so I can try everything without worrying if it makes
the situation worse.

> 2) Apparently some corruption bugs in 3.9 were fixed for 3.10.  It's 
> worth trying say the latest 3.10-rc kernel, to see if can handle it.

Unfortunately, I already tried using 3.10-rc6 in my first mail.

> As the wiki mentions in several places and as is frequently repeated 
> here, btrfs is still under heavy development and the development kernels 
> often have fixes missing in even latest stable.  So unless there's a 
> known regression in the current development kernel that you're 
> purposefully avoiding, really, relatively speaking, in terms of btrfs 
> development, latest mainline kernel stable is in practice already a bit 
> dated, and btrfs testers are encouraged to run the development kernels 
> from rc2 or rc3 at least.  (I can understand not wanting to run them 
> during the commit window, or until rc2/3, as I often hold off during the 
> commit window here, too.  Some even run btrfs-next, before it hits 
> mainline, but I've chosen to stick with mainline here.  That's just 
> simpler all around for me, and the rcs are still current /enough/.)

I'm often upgrading the kernel on my desktop, since I have to
shutdown/boot it anyways because with xen it crashes on resume. But I
don't reboot the notebook much. Probably only every few months when a
new a major version is released.

Anyway, I tried using btrfsck from Josef Bacik's tree (commit f392a28d,
git://github.com/josefbacik/btrfs-progs.git) and it doesn't crash.
Output is this:

> Checking filesystem on /dev/mapper/cryptbtrfs
> UUID: b3a88070-748c-4f19-9c7c-c78e8232797c
> checking extents
> corrupt extent record: key 19642421248 168 45056
> corrupt extent record: key 19642904576 168 40960
> corrupt extent record: key 19643248640 168 49152
> corrupt extent record: key 19644252160 168 49152
> corrupt extent record: key 19644645376 168 40960
> corrupt extent record: key 19645878272 168 4096
> corrupt extent record: key 19646754816 168 524288
> ref mismatch on [19642265600 53248] extent item 18177, found 1
> Backref 19642265600 root 259 owner 1647675 offset 1572864 num_refs 0 not found in extent tree
> Incorrect local backref count on 19642265600 root 259 owner 1647675 offset 1572864 found 1 wanted 0 back 0x95f91a0
> Incorrect local backref count on 19642265600 root 295 owner 1647618 offset 1573046 found 0 wanted 162 back 0x4efb2b0
> Backref disk bytenr does not match extent record, bytenr=19642265600, ref bytenr=82290641
> backpointer mismatch on [19642265600 53248]
> Backref 19642318848 root 259 owner 1647675 offset 1703936 num_refs 0 not found in extent tree
> Incorrect local backref count on 19642318848 root 259 owner 1647675 offset 1703936 found 1 wanted 0 back 0x95f92c0
> Incorrect local backref count on 19642318848 root 259 owner 1647675 offset 148434071453696 found 0 wanted 1 back 0x4efb310
> Backref disk bytenr does not match extent record, bytenr=19642318848, ref bytenr=1
> backpointer mismatch on [19642318848 49152]
[ ... ]
> Errors found in extent allocation tree
> checking free space cache
> checking fs roots
> root 1597 inode 553154 errors 0
>         unresolved ref dir 473796 index 153 namelen 17 name browser_tests.log filetype 1 error 4
>         unresolved ref dir 473796 index 17179869337 namelen 17 name brwser_te6ts.log filetype 0 error 3
> found 62413098968 bytes used err is 1
> total csum bytes: 71717016
> total tree bytes: 2047426560
> total fs tree bytes: 1812643840
> total extent tree bytes: 129286144
> btree space waste bytes: 427714485
> file data blocks allocated: 186676146176
>  referenced 125879046144
> Btrfs v0.20-rc1

Any Ideas?


Thanks
Michael

