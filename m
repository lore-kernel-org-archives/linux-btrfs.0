Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2D2C282C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 02:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC914218D2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 02:47:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ceHmeoac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfAYCrV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Jan 2019 21:47:21 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46846 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfAYCrV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Jan 2019 21:47:21 -0500
Received: by mail-pf1-f195.google.com with SMTP id c73so3989493pfe.13
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2019 18:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=unN80Y48rNrrVXu/6sRcfAWTGcfCJVvruIAPsiog2C0=;
        b=ceHmeoac0VTDnDZ19Z3FWiNRGfU4UHHFVcgASNoVNhj8h47xphmVcr0DGPlhxnqf6D
         IUarxlHrRF7EtfWpeXhZ+lfHdlaU0Isxxu+L1WM5Ky1b+0P3yA6qRmpEIPIlyn5O2JRT
         BJg3gnCKu6uVOTqZxHlvBj0er3Q/DiZNFOhnR5ZZU0CNjvJnzPXU20Zhxutu66Ci6whb
         /durSOf4yhPb500JG/doBE5tOT79anYFN5Jel4yRkb8njwgnpAPvkuZnqPGP1XajPvW4
         wbGvsUfXW/2cusOptLf6soquzMYwpeBCAtsFx3910nmFhU39Fn/A7lffyQd7okl6oqQ5
         JWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=unN80Y48rNrrVXu/6sRcfAWTGcfCJVvruIAPsiog2C0=;
        b=jTVdUR+yVA/Lo83oH0istMxUXvuXym3xROkKhVMiHvNDJy3WhAI3iOEmGs5kLcqJT2
         Eul68qJ1+VP0hy9hTA+lVLaUM1LTyhoBd9FxpRoKrFeo2Wbll3svzTqym8y3SDFC5GRo
         gJdnIjiGFhQyhnr6hDZn0ugCjOv0lV+9tU4tfSgRRcWEnD8ir/o/8kxZ8/AP9Z1MT8SE
         x39F0qVDg7HYMbUd2AMWb8psgU48sXLhzHt8FJllROW2HH9+7JGmGGdQsChbXNUh2uyG
         4KiPQxId3c1p8VArMgwAxItQhg5TIpTgFe859GDOigCec/slXArtv4aoYi5wCpE88Ia/
         JS8A==
X-Gm-Message-State: AJcUukfuUOIQoqHRwh8sy6qICuC/ILkFja1AnUXRcyoqh+EiPspehrwS
        lybTMQL9G4u/YWw5UnOkJ5R67lvAb+qUrd9CfczuHejh
X-Google-Smtp-Source: ALg8bN60q0uqDP2/p3cuWkznSyVoWeylAFv8TgGD6h4bkOy1aCm+6th0l0Tu2a4Wn7j59V8D+CG+9V9UhhyROQWZXps=
X-Received: by 2002:a62:c21c:: with SMTP id l28mr9057865pfg.74.1548384439365;
 Thu, 24 Jan 2019 18:47:19 -0800 (PST)
MIME-Version: 1.0
References: <CAO1Y9wrAzSxGx+LYMPswzN4BbMNs__v7+y=BTZRBAW2bRN5Q1w@mail.gmail.com>
 <a6270ef1-c914-e142-448c-7e7a388f221f@gmx.com> <CAO1Y9wpZ2B-Uik3+zyQQdu4HvjM5RzNoPcv+Hcz1io7e5+D9MQ@mail.gmail.com>
 <CAO1Y9woOf8U7F60=N6oCCA_XKT72ZL-d9roQgG+OdJN8HpraFA@mail.gmail.com>
 <CAJCQCtRJSmyNqi7mDCQzPyMG=xqdtKuxppOAZz3WftCkBUTVOw@mail.gmail.com>
 <CAO1Y9woAF5mY3J2w8hjvBMxuJLf1qqY8b2R=Zjq+apu33oWX+A@mail.gmail.com>
 <CAO1Y9wo=qnLLmwTotC1XH66a89pCBDbfE43_w9ZCqohZVnqPiQ@mail.gmail.com> <6eed65b8-a11a-6a01-e0f0-f4a4a8008ac7@oracle.com>
In-Reply-To: <6eed65b8-a11a-6a01-e0f0-f4a4a8008ac7@oracle.com>
From:   Thiago Ramon <thiagoramon@gmail.com>
Date:   Fri, 25 Jan 2019 00:47:08 -0200
Message-ID: <CAO1Y9wrs8tYM=e_QfLK5tpVv4ZTXcLL2uyy1mS1_XTXPx=pcig@mail.gmail.com>
Subject: Re: Nasty corruption on large array, ideas welcome
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 25, 2019 at 12:36 AM Anand Jain <anand.jain@oracle.com> wrote:
>
>
>
> On 01/24/2019 01:30 AM, Thiago Ramon wrote:
> > Back again with more info.
> >
> > I've done a dump-tree on my array, and from the 71GB of tree data,
> > I've only got the following errors:
> > parent transid verify failed on 31288448466944 wanted 135681 found 135575
> > parent transid verify failed on 31288448466944 wanted 135681 found 135575
> > checksum verify failed on 31288448466944 found 9D027AC2 wanted 79E1C774
> > checksum verify failed on 31288448466944 found 9A1BA23D wanted CFE05F82
> > checksum verify failed on 31288448466944 found 9A1BA23D wanted CFE05F82
> > bad tree block 31288448466944, bytenr mismatch, want=31288448466944,
> > have=198834197030656
> > failed to read 31288448466944 in tree 2
> > parent transid verify failed on 31288448483328 wanted 135681 found 135575
> > parent transid verify failed on 31288448483328 wanted 135681 found 135575
> > checksum verify failed on 31288448483328 found D1816F8A wanted 3562D23C
> > checksum verify failed on 31288448483328 found 51B89701 wanted EECC5745
> > checksum verify failed on 31288448483328 found 51B89701 wanted EECC5745
> > bad tree block 31288448483328, bytenr mismatch, want=31288448483328,
> > have=198834197025536
> > failed to read 31288448483328 in tree 2
> > parent transid verify failed on 17412886069248 wanted 31316 found 31040
> > parent transid verify failed on 17412886069248 wanted 31316 found 31040
> > checksum verify failed on 17412886069248 found 5A0CE056 wanted BEEF5DE0
> > checksum verify failed on 17412886069248 found 52BE5880 wanted A8702E6B
> > checksum verify failed on 17412886069248 found 5A0CE056 wanted BEEF5DE0
> > bad tree block 17412886069248, bytenr mismatch, want=17412886069248, have=0
> > failed to read 17412886069248 in tree 7
>
>   If there are sufficient mirror parent transit verify failed should
>   follow with errors-fixed logs.

Whatever caused the corruption did enough damage it couldn't repair by
itself. I'll be spending the next couple days poking at the trees to
see if I can figure out what happened and how to fix it, but I still
have to learn a lot of details about the BTRFS disk format.

>   I wonder what type of chunks are these.

The disk is currently in a happy mix of RAID1, single and RAID6. I
don't know if it was a coincidence, but a couple minutes before the
first error it had just balanced a metadata block group, possibly the
first one.

>   'btrfs fi df <mnt>'

Data, single: total=7.58TiB, used=7.58TiB
Data, RAID6: total=13.85TiB, used=13.85TiB
System, RAID1: total=8.00MiB, used=8.00MiB
Metadata, RAID1: total=21.00GiB, used=21.00GiB
Metadata, RAID6: total=18.00GiB, used=18.00GiB
GlobalReserve, single: total=0.00B, used=0.00B

>
> Thanks.
>
> > If I'm reading this correctly, it's just a couple bad nodes in the
> > extent tree and one in the checksum tree (assuming they aren't hiding
> > lost nodes behind them). Would it be possible to manually fix those
> > nodes, and if so, how should I proceed? (I have experience in
> > data-recovery on other filesystems, but my knowledge of BTRFS isn't
> > deep enough yet to allow me to even guess where I should start poking,
> > so any pointers are welcome)
> >
> > And thanks again for all help so far
> >
> > On Tue, Jan 22, 2019 at 9:28 PM Thiago Ramon <thiagoramon@gmail.com> wrote:
> >>
> >> On Tue, Jan 22, 2019 at 6:43 PM Chris Murphy <lists@colorremedies.com> wrote:
> >>>
> >>> On Tue, Jan 22, 2019 at 9:41 AM Thiago Ramon <thiagoramon@gmail.com> wrote:
> >>>>
> >>>> Back again with pretty much the same problem, but now without a
> >>>> reasonable cause:
> >>>> I've bought a couple new 8TB disks, recovered everything I needed from
> >>>> my previously damaged FS to a new BTRFS on those 2 drives (single copy
> >>>> mode), double-checked if everything was fine, then wipefs'd the old
> >>>> disks and added the ones that didn't have any issues previously to the
> >>>> new array and rebalanced to RAID6.
> >>>> Everything was running fine through the weekend and I was about 50%
> >>>> done when today:
> >>>> [  +7.733525] BTRFS info (device bcache0): relocating block group
> >>>> 8358036766720 flags data
> >>>> [Jan22 09:20] BTRFS warning (device bcache0): bcache0 checksum verify
> >>>> failed on 31288448499712 wanted A3746F78 found 44D6AEB0 level 1
> >>>> [  +0.460086] BTRFS info (device bcache0): read error corrected: ino 0
> >>>> off 31288448499712 (dev /dev/bcache4 sector 7401171296)
> >>>> [  +0.000199] BTRFS info (device bcache0): read error corrected: ino 0
> >>>> off 31288448503808 (dev /dev/bcache4 sector 7401171304)
> >>>> [  +0.000181] BTRFS info (device bcache0): read error corrected: ino 0
> >>>> off 31288448507904 (dev /dev/bcache4 sector 7401171312)
> >>>> [  +0.000158] BTRFS info (device bcache0): read error corrected: ino 0
> >>>> off 31288448512000 (dev /dev/bcache4 sector 7401171320)
> >>>
> >>> This is corruption being detected and corrected on those listed
> >>> sectors. As this is a bcache device, it's a virtual sector so it's
> >>> hard to tell if it's coming from bcache itself, or the cache device,
> >>> or the backing device.
> >>>
> >> I was using bcache in writeback mode with my old FS, but I've learned
> >> THAT lesson the hard way. This one was just using writearound, unless
> >> bcache REALLY screwed it up I find it hard that it's the source of the
> >> corruption. There were no read or write errors from bcache since the
> >> time the new array went up, and each bcache* device is just a thin
> >> layer over a whole raw disk now.
> >>
> >>>
> >>>> [Jan22 09:21] BTRFS info (device bcache0): found 2050 extents
> >>>> [  +8.055456] BTRFS info (device bcache0): found 2050 extents
> >>>> [Jan22 09:22] BTRFS info (device bcache0): found 2050 extents
> >>>> [  +0.846627] BTRFS info (device bcache0): relocating block group
> >>>> 8356963024896 flags data
> >>>> [Jan22 09:23] BTRFS info (device bcache0): found 2052 extents
> >>>> [  +6.983072] BTRFS info (device bcache0): found 2052 extents
> >>>> [  +0.844419] BTRFS info (device bcache0): relocating block group
> >>>> 8355889283072 flags data
> >>>> [ +33.906101] BTRFS info (device bcache0): found 2058 extents
> >>>> [  +4.664570] BTRFS info (device bcache0): found 2058 extents
> >>>> [Jan22 09:24] BTRFS info (device bcache0): relocating block group
> >>>> 8354815541248 flags data
> >>>> [Jan22 09:25] BTRFS info (device bcache0): found 2057 extents
> >>>> [ +17.650586] BTRFS error (device bcache0): parent transid verify
> >>>> failed on 31288448466944 wanted 135681 found 135575
> >>>
> >>>
> >>> Over 100 generations have passed, and yet it's only finding stale data
> >>> on the desired btrfs byte nr (in btrfs linear space) so it might be
> >>> extent tree corruption again.
> >>>
> >>> It's not possible from the available information to do anything but
> >>> speculate how that much data is being lost or somehow being
> >>> overwritten.
> >>>
> >>>
> >>>> [  +0.088917] BTRFS error (device bcache0): parent transid verify
> >>>> failed on 31288448466944 wanted 135681 found 135575
> >>>> [  +0.001381] BTRFS error (device bcache0): parent transid verify
> >>>> failed on 31288448466944 wanted 135681 found 135575
> >>>> [  +0.003555] BTRFS error (device bcache0): parent transid verify
> >>>> failed on 31288448466944 wanted 135681 found 135575
> >>>> [  +0.005478] BTRFS error (device bcache0): parent transid verify
> >>>> failed on 31288448466944 wanted 135681 found 135575
> >>>> [  +0.003953] BTRFS error (device bcache0): parent transid verify
> >>>> failed on 31288448466944 wanted 135681 found 135575
> >>>> [  +0.000917] BTRFS: error (device bcache0) in
> >>>> btrfs_run_delayed_refs:3013: errno=-5 IO failure
> >>>> [  +0.000017] BTRFS: error (device bcache0) in
> >>>> btrfs_drop_snapshot:9463: errno=-5 IO failure
> >>>
> >>> And -5 I/O error is not a Btrfs error either, it's the detection of an
> >>> IO error from the underlying block device, whether real or virtual.
> >>>
> >> Couldn't figure the source of the -5 either, no kernel logs from
> >> anything byt BTRFS complaining about it. After I umounted the array,
> >> it didn't shown up anymore, and I was able to remount the array with
> >> the skip_bg patch.
> >>
> >>>
> >>>
> >>>> [  +0.000895] BTRFS info (device bcache0): forced readonly
> >>>> [  +0.000902] BTRFS: error (device bcache0) in merge_reloc_roots:2429:
> >>>> errno=-5 IO failure
> >>>> [  +0.000387] BTRFS info (device bcache0): balance: ended with status: -30
> >>>>
> >>>> Couldn't check anything even in RO mode scrub or btrfs check, when I
> >>>> unmounted the array I got a few kernel stack traces:
> >>>> [Jan22 13:58] WARNING: CPU: 3 PID: 9711 at fs/btrfs/extent-tree.c:5986
> >>>> btrfs_free_block_groups+0x395/0x3b0 [btrfs]
> >>>> [  +0.000032] CPU: 3 PID: 9711 Comm: umount Not tainted
> >>>> 4.20.0-042000-generic #201812232030
> >>>> [  +0.000001] Hardware name: Gigabyte Technology Co., Ltd. To be
> >>>> filled by O.E.M./H61M-DS2H, BIOS F6 12/14/2012
> >>>> [  +0.000014] RIP: 0010:btrfs_free_block_groups+0x395/0x3b0 [btrfs]
> >>>> [  +0.000002] Code: 01 00 00 00 0f 84 a0 fe ff ff 0f 0b 48 83 bb d0 01
> >>>> 00 00 00 0f 84 9e fe ff ff 0f 0b 48 83 bb 08 0$
> >>>>   00 00 00 0f 84 9c fe ff ff <0f> 0b 48 83 bb 00 02 00 00 00 0f 84 9a
> >>>> fe ff ff 0f 0b e9 93 fe ff
> >>>> [  +0.000001] RSP: 0018:ffffa3c1c2997d88 EFLAGS: 00010206
> >>>> [  +0.000001] RAX: 0000000020000000 RBX: ffff924aae380000 RCX:
> >>>> 0000000000000000
> >>>> [  +0.000001] RDX: ffffffffe0000000 RSI: ffff924b85970600 RDI:
> >>>> ffff924b85970600
> >>>> [  +0.000001] RBP: ffffa3c1c2997db8 R08: 0000000020000000 R09:
> >>>> ffff924b859706a8
> >>>> [  +0.000000] R10: 0000000000000002 R11: ffff924b973a1c04 R12:
> >>>> ffff924aae380080
> >>>> [  +0.000001] R13: ffff924b8dfe8400 R14: ffff924aae380090 R15:
> >>>> 0000000000000000
> >>>> [  +0.000002] FS:  00007f1bd1076080(0000) GS:ffff924b97380000(0000)
> >>>> knlGS:0000000000000000
> >>>> [  +0.000001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>> [  +0.000000] CR2: 0000562d2eb13c10 CR3: 0000000156910006 CR4:
> >>>> 00000000001606e0
> >>>> [  +0.000001] Call Trace:
> >>>> [  +0.000018]  close_ctree+0x143/0x2e0 [btrfs]
> >>>> [  +0.000012]  btrfs_put_super+0x15/0x20 [btrfs]
> >>>> [  +0.000004]  generic_shutdown_super+0x72/0x110
> >>>> [  +0.000001]  kill_anon_super+0x18/0x30
> >>>> [  +0.000012]  btrfs_kill_super+0x16/0xa0 [btrfs]
> >>>> [  +0.000002]  deactivate_locked_super+0x3a/0x80
> >>>> [  +0.000001]  deactivate_super+0x51/0x60
> >>>> [  +0.000003]  cleanup_mnt+0x3f/0x80
> >>>> [  +0.000001]  __cleanup_mnt+0x12/0x20
> >>>> [  +0.000002]  task_work_run+0x9d/0xc0
> >>>> [  +0.000002]  exit_to_usermode_loop+0xf2/0x100
> >>>> [  +0.000002]  do_syscall_64+0xda/0x110
> >>>> [  +0.000003]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>>> [  +0.000001] RIP: 0033:0x7f1bd14bae27
> >>>> [  +0.000001] Code: 90 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44
> >>>> 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00
> >>>>   00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39
> >>>> 90 0c 00 f7 d8 64 89 01 48
> >>>> [  +0.000001] RSP: 002b:00007ffdb15a75a8 EFLAGS: 00000246 ORIG_RAX:
> >>>> 00000000000000a6
> >>>> [  +0.000002] RAX: 0000000000000000 RBX: 000055df329eda40 RCX:
> >>>> 00007f1bd14bae27
> >>>> [  +0.000000] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
> >>>> 000055df329edc20
> >>>> [  +0.000001] RBP: 0000000000000000 R08: 000055df329eea70 R09:
> >>>> 00000000ffffffff
> >>>> [  +0.000001] R10: 000000000000000b R11: 0000000000000246 R12:
> >>>> 000055df329edc20
> >>>> [  +0.000001] R13: 00007f1bd15e18c4 R14: 0000000000000000 R15:
> >>>> 00007ffdb15a7818
> >>>>
> >>>> Now I'm back in a very similar situation as before, btrfs check gets me:
> >>>> Opening filesystem to check...
> >>>> checksum verify failed on 24707469082624 found 451E87BF wanted
> >>>> A1FD3A09
> >>>> checksum verify failed on 24707469082624 found 2C2AEBE0 wanted
> >>>> D6652D6A
> >>>> checksum verify failed on 24707469082624 found 2C2AEBE0 wanted
> >>>> D6652D6A
> >>>> bad tree block 24707469082624, bytenr mismatch, want=24707469082624,
> >>>> have=231524568072192
> >>>> Couldn't read tree root
> >>>> ERROR: cannot open file system
> >>>>
> >>>> I could do it all again, but first, what can be wrong here? This array
> >>>> was working for some 4 years until it went bad a few weeks ago, and
> >>>> now the FS got badly corrupted again without any warnings. Any
> >>>> suggestions? Bad RAM, SAS controller going bad, some weirdly behaving
> >>>> disk? I need to figure out what can be failing before I try another
> >>>> recovery.
> >>>
> >>> I think it's specifically storage stack related. I think you'd have
> >>> more varied and weird problems if it were memory corruption, but
> >>> that's speculation on my part.
> >>
> >> I've done a quick memory test with stressapptest and it was fine, so
> >> if it's the memory it's something very localized.
> >>>
> >>> I'd honestly simplify the layout and not use bcache at all, only use
> >>> Btrfs directly on the whole drives, although I think it's reasonably
> >>> simple to use dmcrypt if needed/desired. But it's still better for
> >>> troubleshooting to make the storage stack as simple as possible.
> >>> Without more debugging information from all the layers, it's hard to
> >>> tell which layer to blame without just using the big stick called
> >>> process of elimination.
> >>>
> >>> Maybe Qu has some ideas based on the call trace though - I can't parse it.
> >>>
> >>> --
> >>> Chris Murphy
