Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC62EC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 07:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C76420685
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 07:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="sjtJUgkD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C76420685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389970AbeKWSgR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 13:36:17 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42171 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387556AbeKWSgR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 13:36:17 -0500
Received: by mail-lf1-f68.google.com with SMTP id l10so8067411lfh.9
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 23:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=DY1PDTePuQei2PcK6+Ki4CbLtM+4BS/lUSYf5zAoHqA=;
        b=sjtJUgkDJg1GBEaJKkKijS2w2k6H/yzfVQLikng3VCLzyIXGL4kRdtz9RA8pOg9VXw
         H1QK9zb4LN85rIvLaXW5IVccKXRyDBaSIUM39/PFBjKv0NjeG0LDmSH9xX3EsYsY6/2Y
         0X4RdICkazUNf63qgiB5EOAAl1PGfXJdKkf5goQIP+5yVcMM4idZaAwtEIwdD7dVUcEF
         U+VNRw3WOlcy/xX1ZvgdRIjBWPettS50xO+P2DfnXET6jXbvUyhfnyLt6hcUbfwPvAA0
         8tymFOjmf8HTenHuwpvN2rQhSo9prpOEzKjAJW31lwmePbvtrWCCvolwrlRIDO3aKQsM
         7svQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=DY1PDTePuQei2PcK6+Ki4CbLtM+4BS/lUSYf5zAoHqA=;
        b=rNA2Oqk4D4KFYSB6drTzu3yYeSFn027Na9OjRQL8HBZaRNfe5q9mxC4Yb3fTEkQAo6
         U7ZxCtq65Zf8funZyr0nPallfxY/UAEimTALm35x8/IGNvNu5HlI/hdadrB4Nrn382I3
         jVe0KEI8XBoLuqOq9ndnrkpFBuAtx64ruPASZBehtI4MBKqR8PnBFLuyFQbwFC2906fU
         gonbTW76xH2OcWBPfrdmc8jKkte+F69OWJhB+7KVA9u/6z7lw9nn+GrsDqU4Us63iZ4x
         x174gy/W3y16Es51+WrPBrCRNcp6IxhMJhLKY8AQTy7HJjnHFO43vsIpEOoy+VQakeQc
         CWtw==
X-Gm-Message-State: AGRZ1gL72ReVPbsNbKZwnuwdFL4ZrjUMlyqG3/SWEUTTTb0kfxZOq2TO
        CpKuXhE/fduiNd+d/GYqRtakmNjDbpEThzQ44esj0tRyls8=
X-Google-Smtp-Source: AJdET5cgLQlco4LwfBkD9X2xQC4k59iQmzdEqh7pTv/FWb1dh8xfhkrtuZIz2O7Vd2rgWuKz6IxcUrZODDMOTcsY6PI=
X-Received: by 2002:a19:e01e:: with SMTP id x30mr8136694lfg.89.1542959590286;
 Thu, 22 Nov 2018 23:53:10 -0800 (PST)
MIME-Version: 1.0
References: <CAJUWh6qyHerKg=-oaFN+USa10_Aag5+SYjBOeLCX1qM+WcDUwA@mail.gmail.com>
In-Reply-To: <CAJUWh6qyHerKg=-oaFN+USa10_Aag5+SYjBOeLCX1qM+WcDUwA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 23 Nov 2018 00:52:59 -0700
Message-ID: <CAJCQCtSRgX+nffcycRgPhYLZN7_HNL-OM2wgyw7MpLLWqzY5dw@mail.gmail.com>
Subject: Re:
To:     andy.leadbetter@theleadbetters.com,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 11:41 PM Andy Leadbetter
<andy.leadbetter@theleadbetters.com> wrote:
>
> I have a failing 2TB disk that is part of a 4 disk RAID 6 system.  I
> have added a new 2TB disk to the computer, and started a BTRFS replace
> for the old and new disk.  The process starts correctly however some
> hours into the job, there is an error and kernel oops. relevant log
> below.

The relevant log is the entire dmesg, not a snippet. It's decently
likely there's more than one thing going on here. We also need full
output of 'smartctl -x' for all four drives, and also 'smartctl -l
scterc' for all four drives, and also 'cat
/sys/block/sda/device/timeout' for all four drives. And which bcache
mode you're using.

The call trace provided is from kernel 4.15 which is sufficiently long
ago I think any dev working on raid56 might want to see where it's
getting tripped up on something a lot newer, and this is why:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/fs/btrfs/raid56.c?id=v4.19.3&id2=v4.15.1

That's a lot of changes in just the raid56 code between 4.15 and 4.19.
And then in you call trace, btrfs_dev_replace_start is found in
dev-replace.c which likewise has a lot of changes. But then also, I
think 4.15 might still be in the era where it was not recommended to
use 'btrfs dev replace' for raid56, only non-raid56. I'm not sure if
the problems with device replace were fixed, and if they were fixed
kernel or progs side. Anyway, the latest I recall, it was recommended
on raid56 to 'btrfs dev add' then 'btrfs dev remove'.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/fs/btrfs/dev-replace.c?id=v4.19.3&id2=v4.15.1

And that's only a few hundred changes for each. Check out inode.c -
there are over 2000 changes.


> The disks are configured on top of bcache, in 5 arrays with a small
> 128GB SSD cache shared.  The system in this configuration has worked
> perfectly for 3 years, until 2 weeks ago csum errors started
> appearing.  I have a crashplan backup of all files on the disk, so I
> am not concerned about data loss, but I would like to avoid rebuild
> the system.

btrfs-progs 4.17 still considers raid56 experimental, not for
production use. And three years ago, the current upstream kernel
released was 4.3 so I'm gonna guess the kernel history of this file
system goes back older than that, very close to raid56 code birth. And
then adding bcache to this mix just makes it all the more complicated.



>
> btrfs dev stats shows
> [/dev/bcache0].write_io_errs    0
> [/dev/bcache0].read_io_errs     0
> [/dev/bcache0].flush_io_errs    0
> [/dev/bcache0].corruption_errs  0
> [/dev/bcache0].generation_errs  0
> [/dev/bcache1].write_io_errs    0
> [/dev/bcache1].read_io_errs     20
> [/dev/bcache1].flush_io_errs    0
> [/dev/bcache1].corruption_errs  0
> [/dev/bcache1].generation_errs  14
> [/dev/bcache3].write_io_errs    0
> [/dev/bcache3].read_io_errs     0
> [/dev/bcache3].flush_io_errs    0
> [/dev/bcache3].corruption_errs  0
> [/dev/bcache3].generation_errs  19
> [/dev/bcache2].write_io_errs    0
> [/dev/bcache2].read_io_errs     0
> [/dev/bcache2].flush_io_errs    0
> [/dev/bcache2].corruption_errs  0
> [/dev/bcache2].generation_errs  2


3 of 4 drives have at least one generation error. While there are no
corruptions reported, generation errors can be really tricky to
recover from at all. If only one device had only read errors, this
would be a lot less difficult.


> I've tried the latest kernel, and the latest tools, but nothing will
> allow me to replace, or delete the failed disk.

If the file system is mounted, I would try to make a local backup ASAP
before you lose the whole volume. Whether it's LVM pool of two drives
(linear/concat) with XFS, or if you go with Btrfs -dsingle -mraid1
(also basically a concat) doesn't really matter, but I'd get whatever
you can off the drive. I expect avoiding a rebuild in some form or
another is very wishful thinking and not very likely.

The more changes are made to the file system, repair attempts or
otherwise writing to it, decreases the chance of recovery.

-- 
Chris Murphy
