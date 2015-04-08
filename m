Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36684 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbbDHSgz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 14:36:55 -0400
Received: by iebrs15 with SMTP id rs15so82072036ieb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2015 11:36:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5525731C.2080709@neo-zeon.de>
References: <CAPL5yKeARUyaM3YiQRmEPvE=4LX2-7gsyyUJDULRnD388vNhxg@mail.gmail.com>
	<CAPL5yKcemHpLHm1ntBYoM43Zejv86b_WX4Cvk5naAE=vtrmkxg@mail.gmail.com>
	<5525731C.2080709@neo-zeon.de>
Date: Wed, 8 Apr 2015 14:36:54 -0400
Message-ID: <CAPL5yKew_pLumUeV7owwX5=Jy+ciqY-+AtGeApo+M-G4LpQurA@mail.gmail.com>
Subject: Re: Recovering BTRFS from bcache failure.
From: Dan Merillat <dan.merillat@gmail.com>
To: Cameron Berkenpas <cam@neo-zeon.de>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a known bug with bcache and enabling discard, it was discarding
sections containing data it wanted.  After a reboot bcache refused to
accept the cache data, and of course it was dirty because I'm frankly
too stupid to breathe sometimes.

So yes, it's a bcache issue, but that's unresolvable.  I'm trying to
rescue the btrfs data that it trashed.


On Wed, Apr 8, 2015 at 2:27 PM, Cameron Berkenpas <cam@neo-zeon.de> wrote:
> Hello,
>
> I had some luck in the past with btrfs restore using the -r option. I don't
> recall how I determined the roots... Maybe I tried random numbers? I was
> able to recover nearly all of my data from a bcache related crash from over
> a year ago.
>
> What kind of bcache failure did you see? I've been doing some testing
> recently and ran into 2 bcache failures. With both of these failures, I had
> a ' bad btree header at bucket' error message (which is entirely different
> from the crash I had over a year back). I'm currently trying a different SSD
> to see if that alleviates the issue. The error makes me think that it's a
> bcache specific issue that's unrelated to btrfs or possibly (in my case) an
> issue with the previous SSD.
>
> Did you encounter this same error?
>
> With my 2 most recent crashes, I didn't try to recover very hard (or even
> try 'btrfs recover; at all) as I've been taking daily backups. I did try
> btrfsck, and not only would it fail, it would segfault.
>
> -Cameron
>
>
> On 04/08/2015 11:07 AM, Dan Merillat wrote:
>
> Any ideas on where to start with this?  I did flush the cache out to
> disk before I made changes to the bcache configuration, so there
> shouldn't be anything completely missing, just some bits of stale
> metadata.  If I can get the tools to take the closest match and run
> with it it would probably recover nearly everything.
>
> At worst, is there a way to scan the metadata blocks and rebuild from
> found extent-trees?
>
>
>
>
> On Tue, Apr 7, 2015 at 11:40 PM, Dan Merillat <dan.merillat@gmail.com>
> wrote:
>
> Bcache failures are nasty, because they leave a mix of old and new
> data on the disk.  In this case, there was very little dirty data, but
> of course the tree roots were dirty and out-of-sync.
>
> fileserver:/usr/src/btrfs-progs# ./btrfs --version
> Btrfs v3.18.2
>
> kernel version 3.18
>
> [  572.573566] BTRFS info (device bcache0): enabling auto recovery
> [  572.573619] BTRFS info (device bcache0): disk space caching is enabled
> [  574.266055] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.276952] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.277008] BTRFS: failed to read tree root on bcache0
> [  574.277187] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.277356] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.277398] BTRFS: failed to read tree root on bcache0
> [  574.285955] BTRFS (device bcache0): parent transid verify failed on
> 7567965720576 wanted 613689 found 613694
> [  574.298741] BTRFS (device bcache0): parent transid verify failed on
> 7567965720576 wanted 613689 found 610499
> [  574.298804] BTRFS: failed to read tree root on bcache0
> [  575.047079] BTRFS (device bcache0): bad tree block start 0 7567954464768
> [  575.111495] BTRFS (device bcache0): parent transid verify failed on
> 7567954464768 wanted 613688 found 613685
> [  575.111559] BTRFS: failed to read tree root on bcache0
> [  575.121749] BTRFS (device bcache0): bad tree block start 0 7567954214912
> [  575.131803] BTRFS (device bcache0): parent transid verify failed on
> 7567954214912 wanted 613687 found 613680
> [  575.131866] BTRFS: failed to read tree root on bcache0
> [  575.180101] BTRFS: open_ctree failed
>
> all the btrfs tools throw up their hands with similar errors:
> ileserver:/usr/src/btrfs-progs# btrfs restore /dev/bcache0 -l
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Could not open root, trying backup super
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Could not open root, trying backup super
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Could not open root, trying backup super
>
>
> fileserver:/usr/src/btrfs-progs# ./btrfsck --repair /dev/bcache0
> --init-extent-tree
> enabling repair mode
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Couldn't open file system
>
> Annoyingly:
> # ./btrfs-image -c9 -t4 -s -w /dev/bcache0 /tmp/test.out
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Open ctree failed
> create failed (Success)
>
> So I can't even send an image for people to look at.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
