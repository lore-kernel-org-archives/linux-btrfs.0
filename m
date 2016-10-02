Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38539 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbcJBUqW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Oct 2016 16:46:22 -0400
Received: by mail-wm0-f42.google.com with SMTP id p138so117066692wmb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 13:46:21 -0700 (PDT)
Received: from localhost (host86-130-216-236.range86-130.btcentralplus.com. [86.130.216.236])
        by smtp.gmail.com with ESMTPSA id r142sm10974692wme.10.2016.10.02.13.46.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Oct 2016 13:46:19 -0700 (PDT)
Date: Sun, 2 Oct 2016 21:46:18 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unable to open ctree
Message-ID: <20161002204618.j2heaouubb7pday6@tiamat>
References: <20161002181754.wxved3j66dzrvfoc@tiamat>
 <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
 <20161003012225.089c4d38@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161003012225.089c4d38@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Roman,


On 03/10/16, Roman Mamedov wrote:
> On Sun, 2 Oct 2016 13:29:56 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
> 
> > Well short of a bug, the problem aren't the checksums. The problem is
> > the metadata is wrong, so if you recalculate checksums you're likely
> > end up with an even more corrupted file system because it'll start out
> > trusting bad metadata.
> 
> It appears that metadata got created with profile "single", because the device
> is SSD. If this was DUP metadata, this entire problem wouldn't happen.
> It is a terrible idea to downgrade metadata to single on detecting SSDs at
> mkfs. The original rationale was that "SSDs will deduplicate it anyways", but
> there are many ways things can corrupt way before reaching the SSD (from the
> point of view of which it will look like the computer sent two different
> metadata blocks, if one got corrupted in flight), and secondly, the ability of
> SSDs to perfectly deduplicate small 4K sized pieces of data at hundreds of
> megabytes in read/write speeds is VASTLY overestimated here.

I agree that the wear in SSDs due to metadata dublications is
overestimated and since my partition appears to be screwed I will make
sure next time to force it to have another copy there.

My progress from the repairs which both failed are: https://ptpb.pw/CtbC

Next step is initialize the extent tree
btrfs check --init-extent-tree --repair /dev/sda3

Thanks,

-- 
Leonidas Spyropoulos

A: Because it messes up the order in which people normally read text.
Q: Why is it such a bad thing?
A: Top-posting.
Q: What is the most annoying thing on usenet and in e-mail?

