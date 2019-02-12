Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43164C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 12:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF9042075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 12:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOBOcmVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfBLMFz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:05:55 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:37478 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfBLMFz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 07:05:55 -0500
Received: by mail-it1-f195.google.com with SMTP id b5so6902016iti.2
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 04:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7C2yfH5w1FdqeDnx7VPVebiCayzYKUR1clYsDwF8TAM=;
        b=pOBOcmVSDrq8re9tAsUpT37R927aPXBxftIQt1GANUS5GNOMwuXS2lu9jEYRiOoth9
         tvl09QrBsr09uARlDn5zsztRvBogr9dd0Adt+gPbFhhqTjSbi7IkW4pGp4XZLX48IhCo
         v6G8DRZ7Mmnoqta34qV0lSXwNgTzDFil+x6g8XIV4heO1rZhnkWzvzz0IEwNAMWoho4b
         BagN7p/q6DNK8bGx0FONBCsbhmxu0iRPMdu8uVyJv4Cr3uJhnxFQ4Ekm7vOc4I+F6EGB
         oDuJl9axFzqlDt4O4M/dNs2GYiToa6ERfPOgIL1ReNLgmIRHc/Ji7Amp2MRIPo97jmeL
         LZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7C2yfH5w1FdqeDnx7VPVebiCayzYKUR1clYsDwF8TAM=;
        b=LXw/3ki5YVV2H/5N0l5Imvan9D4uKPQsSGb+bdxoemM90Ga0neHo+wySXt0A46cUTh
         XHEjxGuARjUXyi1Nk457f6cKgCEU6HyZ3KvVqyGjv4dOXkHh041WOWcVw8WNXhdkdPef
         OlBWCxoLFvuuaD5x6UfMag89VeL4lVSlfvePwQU4rLKR+JcZJlX1/gt7EIz35BtXP/Xm
         P9Yk+4nvilwfopEo/mjMXwLL+Epe2ZJq3+hoqXGgY/0ize7DlHhVj1AxfBTrPL7AASfN
         NBGtNzsV23fNzb8bZRLTmzdzxJugdSklPsoMtNyDUeCCIS6Wuq3cO2xyBNeXr6Xd1xR5
         148Q==
X-Gm-Message-State: AHQUAubzHq56GRvighGD7FrRznObyn9mB52gCX4PfeKzSJMP41AqnjOM
        qsyNEcndu01aI8QLUERiKj3lf1V+faw=
X-Google-Smtp-Source: AHgI3IZ+4lA0RitpWv03BMVnsUc4L9l3OK2kvmo/UQsc91eH8AJNuZkul/fSlJPUMso/xJRhoYWqjA==
X-Received: by 2002:a24:9144:: with SMTP id i65mr1835001ite.115.1549973153750;
        Tue, 12 Feb 2019 04:05:53 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id g74sm1246330itg.29.2019.02.12.04.05.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 04:05:52 -0800 (PST)
Subject: Re: Corrupted filesystem, looking for guidance
To:     =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <09f37190-bc2a-c0fa-a467-18a30d360d6f@gmail.com>
Date:   Tue, 12 Feb 2019 07:05:50 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-02-11 22:16, Sébastien Luttringer wrote:
> Hello,
> 
> The context is a BTRFS filesystem on top of an md device (raid5 on 6 disks).
> System is an Arch Linux and the kernel was a vanilla 4.20.2.
> 
> # btrfs fi us /home
> Overall:
>      Device size:                  27.29TiB
>      Device allocated:              5.01TiB
>      Device unallocated:           22.28TiB
>      Device missing:                  0.00B
>      Used:                          5.00TiB
>      Free (estimated):             22.28TiB      (min: 22.28TiB)
>      Data ratio:                       1.00
>      Metadata ratio:                   1.00
>      Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:4.95TiB, Used:4.95TiB
>     /dev/md127      4.95TiB
> 
> Metadata,single: Size:61.01GiB, Used:57.72GiB
>     /dev/md127     61.01GiB
> 
> System,single: Size:36.00MiB, Used:560.00KiB
>     /dev/md127     36.00MiB
> 
> Unallocated:
>     /dev/md127     22.28TiB
> 
> I'm not able to find the root cause of the btrfs corruption. All disks looks
> healthy (selftest ok, no error logged), no kernel trace of link failure or
> something.
> I run a check on the md layer, and 2 mismatch was discovered:
> Feb 11 04:02:35 kernel: md127: mismatch sector in range 490387096-490387104
> Feb 11 04:31:14 kernel: md127: mismatch sector in range 1024770720-1024770728
> I run a repair (resync) but mismatch are still around after. 😱
> 
> The first BTRFS warning was:
> Feb 07 11:27:57 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> 
> 
> After that, the userland process crashed. Few days ago, I run it again. It
> crashes again but filesystem become read-only
> 
> Feb 10 01:07:02 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS error (device md127): error loading props for ino
> 9930722 (root 5): -5
> Feb 10 01:07:03 kernel: BTRFS error (device md127): error loading props for ino
> 9930722 (root 5): -5
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 01:07:03 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:16:24 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:16:28 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:27:34 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 03:27:40 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 05:59:34 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 05:59:34 kernel: BTRFS error (device md127): error loading props for ino
> 9930722 (root 5): -5
> Feb 10 05:59:34 kernel: BTRFS warning (device md127): md127 checksum verify
> failed on 4140883394560 wanted 7B4B0431 found B809FBEE level 0
> Feb 10 05:59:34 kernel: BTRFS info (device md127): failed to delete reference
> to fImage%252057(1).jpg, inode 9930722 parent 58718826
> Feb 10 05:59:34 kernel: BTRFS: error (device md127) in
> __btrfs_unlink_inode:3971: errno=-5 IO failure
> Feb 10 05:59:34 kernel: BTRFS info (device md127): forced readonly
> 
> The btrfs check report:
> 
> # btrfs check -p /dev/md127
> Opening filesystem to check...
> Checking filesystem on /dev/md127
> UUID: 64403592-5a24-4851-bda2-ce4b3844c168
> [1/7] checking root items                      (0:10:21 elapsed, 10056723 items
> checked)
> [2/7] checking extents                         (0:04:59 elapsed, 155136 items
> checked)
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B043109 items
> checked)
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> ref mismatch on [2622304964608 28672] extent item 1, found 0sed, 3783066 items
> checked)
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622304964608 root 5 owner 9930722 offset 0
> found 0 wanted 1 back 0x55d61387cd40
> backref disk bytenr does not match extent record, bytenr=2622304964608, ref
> bytenr=0
> backpointer mismatch on [2622304964608 28672]
> owner ref check failed [2622304964608 28672]
> ref mismatch on [2622304993280 262144] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622304993280 root 5 owner 9930724 offset 0
> found 0 wanted 1 back 0x55d61387ce70
> backref disk bytenr does not match extent record, bytenr=2622304993280, ref
> bytenr=0
> backpointer mismatch on [2622304993280 262144]
> owner ref check failed [2622304993280 262144]
> ref mismatch on [2622305255424 4096] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305255424 root 5 owner 9930727 offset 0
> found 0 wanted 1 back 0x55d61387cfa0
> backref disk bytenr does not match extent record, bytenr=2622305255424, ref
> bytenr=0
> backpointer mismatch on [2622305255424 4096]
> owner ref check failed [2622305255424 4096]
> ref mismatch on [2622305259520 8192] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305259520 root 5 owner 9930731 offset 0
> found 0 wanted 1 back 0x55d61387d0d0
> backref disk bytenr does not match extent record, bytenr=2622305259520, ref
> bytenr=0
> backpointer mismatch on [2622305259520 8192]
> owner ref check failed [2622305259520 8192]
> ref mismatch on [2622305267712 188416] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305267712 root 5 owner 9930733 offset 0
> found 0 wanted 1 back 0x55d61387d200
> backref disk bytenr does not match extent record, bytenr=2622305267712, ref
> bytenr=0
> backpointer mismatch on [2622305267712 188416]
> owner ref check failed [2622305267712 188416]
> ref mismatch on [2622305456128 4096] extent item 1, found 0
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> checksum verify failed on 4140883394560 found B809FBEE wanted 7B4B0431
> Csum didn't match
> incorrect local backref count on 2622305456128 root 5 owner 9930734 offset 0
> found 0 wanted 1 back 0x55d61387d330
> backref disk bytenr does not match extent record, bytenr=2622305456128, ref
> bytenr=0
> backpointer mismatch on [2622305456128 4096]
> owner ref check failed [2622305456128 4096]
> owner ref check failed [4140883394560 16384]
> [2/7] checking extents                         (0:31:38 elapsed, 3783074 items
> checked)
> ERROR: errors found in extent allocation tree or chunk allocation
> [3/7] checking free space cache                (0:03:58 elapsed, 5135 items
> checked)
> [4/7] checking fs roots                        (1:02:53 elapsed, 139654 items
> checked)
> 
> I tried to mount the filesystem with nodatasum but I was not able to delete the
> suspected wrong directory. FS was remounted RO.
> btrfs inspect-internal logical-resolve and btrfs inspect-internal inode-resolve
> are not able to resolve logical and inode path from the above errors.
> 
> How could I save my filesystem? Should I try --repair or --init-csum-tree?
Have you checked your RAM yet?  This looks to me like cumulative damage 
from bad hardware, and if you've ruled the disks out, RAM is the next 
most likely culprit.

Until you figure out what is causing the problem in the first place 
though, there's not much point in trying to fix it (do make sure you 
have current backups however).

