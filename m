Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33083 "EHLO
	mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbcHGTXB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Aug 2016 15:23:01 -0400
Received: by mail-qt0-f173.google.com with SMTP id w38so195551285qtb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Aug 2016 12:23:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSbrEy-e6+q79NFxkjpyGQqMiY_gDa3vnZdUjUjCCSBjg@mail.gmail.com>
References: <CAPT_Aj+gzL6Pnz4JeN2Aco_Enq__3Pd=qYnC4M8=b-8Q=UPTmA@mail.gmail.com>
 <CAJCQCtSbrEy-e6+q79NFxkjpyGQqMiY_gDa3vnZdUjUjCCSBjg@mail.gmail.com>
From: Chris McFaul <mcfaul@gmail.com>
Date: Sun, 7 Aug 2016 20:22:40 +0100
Message-ID: <CAPT_AjKdnR0uh4oM20xUQJ3GuHP-fVDbcciNawLi1X--wYpu7Q@mail.gmail.com>
Subject: Re: Unmountable and unrepairable BTRFS
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

unfortunately that was one of the first things I tried

I get:

[root@rockstor 1]# mount -o usebackuproot /dev/sdp /mnt2/1
mount: wrong fs type, bad option, bad superblock on /dev/sdp,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so.

dmesg:

[18647.368488] BTRFS info (device sdk): trying to use backup root at mount time
[18647.368496] BTRFS info (device sdk): disk space caching is enabled
[18647.368499] BTRFS: has skinny extents
[18647.693213] BTRFS info (device sdk): bdev /dev/sdt errs: wr 19344,
rd 134315147, flush 6448, corrupt 0, gen 0
[18647.737594] btree_readpage_end_io_hook: 147 callbacks suppressed
[18647.737601] BTRFS error (device sdk): bad tree block start
12198095107859028614 78555517419520
[18647.789784] BTRFS error (device sdk): bad tree block start
3080147678807299231 78555533541376
[18647.815819] BTRFS error (device sdk): bad tree block start
3628159343105622100 78555533066240
[18647.869602] BTRFS error (device sdk): bad tree block start
1695590055520167483 78555584937984
[18647.871838] BTRFS error (device sdk): bad tree block start
1695590055520167483 78555584937984
[18647.888870] BTRFS error (device sdk): bad tree block start
11385553161725968518 78555550433280
[18647.891563] BTRFS error (device sdk): bad tree block start
15786696425166886725 78555584921600
[18647.900267] BTRFS error (device sdk): bad tree block start
15786696425166886725 78555584921600
[18647.924833] BTRFS error (device sdk): bad tree block start
14916401925551750305 78555584954368
[18647.948461] BTRFS error (device sdk): bad tree block start
9661822219308924631 78555553529856
[18648.315673] BTRFS error (device sdk): parent transid verify failed
on 68571677016064 wanted 55973 found 48001
[18648.381126] BTRFS error (device sdk): parent transid verify failed
on 68571493269504 wanted 55973 found 49520
[18648.394085] BTRFS error (device sdk): parent transid verify failed
on 68571891154944 wanted 55973 found 48001
[18649.300650] BTRFS error (device sdk): parent transid verify failed
on 51128231329792 wanted 55830 found 28224
[18649.321490] BTRFS error (device sdk): parent transid verify failed
on 51128231329792 wanted 55830 found 28224
[18649.322825] BTRFS error (device sdk): parent transid verify failed
on 51128231329792 wanted 55830 found 28224
[18649.323809] BTRFS: Failed to read block groups: -5
[18649.356944] BTRFS: open_ctree failed


but thanks for the suggestion

all the issues seem to be sdk.. but I'm not sure if that is actually
an issue with sdk or if it is just that the first device it is trying
to mount.  I'm half tempted to physically remove sdk and try to mount
degraded.  but I will wait to see if the developers can give any
further advice before doing anything which is potentially destructive

On 7 August 2016 at 20:15, Chris Murphy <lists@colorremedies.com> wrote:
> The btrfs check link appears to be stale, no btrfs check.
>
> find root seems promising
> Well block 72701214523392(gen: 56072 level: 1) seems good, but
> generation/level doesn't match, want gen: 56073 level: 1
>
> Those are quite close, so what I'd say off hand is that mounting -o
> usebackuproot should help.
>
>
> Chris Murphy
