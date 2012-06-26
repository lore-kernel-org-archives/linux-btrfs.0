Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48619 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab2FZSnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 14:43:07 -0400
Received: by yenl2 with SMTP id l2so236921yen.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 11:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120626095816.GH25572@carfax.org.uk>
References: <20120605190921.GM15986@carfax.org.uk>
	<CAHf9xvbTL6DFP_KdpJrphWYTNJOqHgpzi+i44ZGjTg0oBY1V+w@mail.gmail.com>
	<20120626095816.GH25572@carfax.org.uk>
Date: Tue, 26 Jun 2012 21:43:06 +0300
Message-ID: <CAHf9xvYpBm6Zwg=dTyxvzd_XQrXbBRvNbzcEZh2Y4_CU3XJ3Tw@mail.gmail.com>
Subject: Re: New btrfs-progs integration branch
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Alex Lyakas <alex.bolshoy.btrfs@gmail.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, Hugo.
At this point I mostly want to learn and stay up-to-date with new
patches coming in.

Alex.



On Tue, Jun 26, 2012 at 12:58 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Jun 26, 2012 at 11:58:41AM +0300, Alex Lyakas wrote:
>> Hi Hugo,
>> forgive me, but I am somewhat confused.
>> What is the "main" repo of btrfs-progs, if there is such thing?
>> I see patches coming in, but no updates to
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git,
>> which I thought was the one.
>>
>> Can you pls clarify where should I pull updates from for btrfs-progs?
>
>   The official source for btrfs-progs is Chris's one, at the URL
> above. The integration repo is kind of a staging area where I pull in
> as many patches as I can and get them a bit more visibility. We don't
> really have a well-defined workflow here.
>
>   It depends on what you intend doing: if you want to make packages
> for your distribution, use Chris's repo. If you want something
> reasonably stable and tested, use Chris's repo. If there's some
> experimental kernel feature you want to test out, use integration. If
> you want to be helpful and test out new patches and report problems
> with them, use integration.
>
>   Hugo.
>
>> Thanks,
>> Alex.
>>
>>
>>
>> On Tue, Jun 5, 2012 at 10:09 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >   I've just pushed out a new integration branch to my git repo. This
>> > is purely bugfix patches -- there are no new features in this issue of
>> > the integration branch. I've got a stack of about a dozen more patches
>> > with new features in them still to go. I'll be working on those
>> > tomorrow. As always, there's minimal testing involved here, but it
>> > does at least compile on my system(*).
>> >
>> >   The branch is fetchable with git from:
>> >
>> > http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20120605
>> >
>> >   And viewable in human-readable form at:
>> >
>> > http://git.darksatanic.net/cgi/gitweb.cgi?p=btrfs-progs-unstable.git
>> >
>> >   Shortlog is below.
>> >
>> >   Hugo.
>> >
>> > (*) "I don't care about works-on-my-machine. We are not shipping your
>> > machine!"
>> >
>> > ----
>> >
>> > Akira Fujita (1):
>> >      Btrfs-progs: Fix manual of btrfs command
>> >
>> > Chris Samuel (1):
>> >      Fix "set-dafault" typo in cmds-subvolume.c
>> >
>> > Csaba Tóth (1):
>> >      mkfs.btrfs on ARM
>> >
>> > Goffredo Baroncelli (1):
>> >      scrub_fs_info( ) file handle leaking
>> >
>> > Hubert Kario (2):
>> >      Fix segmentation fault when opening invalid file system
>> >      man: fix btrfs man page formatting
>> >
>> > Jan Kara (1):
>> >      mkfs: Handle creation of filesystem larger than the first device
>> >
>> > Jim Meyering (5):
>> >      btrfs_scan_one_dir: avoid use-after-free on error path
>> >      mkfs: use strdup in place of strlen,malloc,strcpy sequence
>> >      restore: don't corrupt stack for a zero-length command-line argument
>> >      avoid several strncpy-induced buffer overruns
>> >      mkfs: avoid heap-buffer-read-underrun for zero-length "size" arg
>> >
>> > Josef Bacik (3):
>> >      Btrfs-progs: make btrfsck aware of free space inodes
>> >      Btrfs-progs: make btrfs filesystem show <uuid> actually work
>> >      btrfs-progs: enforce block count on all devices in mkfs
>> >
>> > Miao Xie (3):
>> >      Btrfs-progs: fix btrfsck's snapshot wrong "unresolved refs"
>> >      Btrfs-progs, btrfs-corrupt-block: fix the wrong usage
>> >      Btrfs-progs, btrfs-map-logical: Fix typo in usage
>> >
>> > Phillip Susi (2):
>> >      btrfs-progs: removed extraneous whitespace from mkfs man page
>> >      btrfs-progs: document --rootdir mkfs switch
>> >
>> > Sergei Trofimovich (2):
>> >      Makefile: use $(CC) as a compilers instead of $(CC)/gcc
>> >      Makefile: use $(MAKE) instead of hardcoded 'make'
>> >
>> > Shawn Bohrer (1):
>> >      btrfs-progs: Update resize documentation
>> >
>> > Wang Sheng-Hui (1):
>> >      btrfs-progs: cleanup: remove the redundant BTRFS_CSUM_TYPE_CRC32 macro def
>> >
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>          --- ...  one ping(1) to rule them all, and in the ---
>                         darkness bind(2) them.
