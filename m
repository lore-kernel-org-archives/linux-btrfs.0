Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35916 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbcGGBqC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 21:46:02 -0400
Received: by mail-oi0-f50.google.com with SMTP id f189so5311512oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 18:46:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160707012246.3559fd0a@jupiter.sol.kaishome.de>
References: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com>
 <CAPmG0jYfdYt81E8oaky53eYmy69tWgpLkRFWXRxGF_d3g3Uhjg@mail.gmail.com>
 <EDF51D2D-A311-47DF-BFF7-F5C855B9E96D@gmail.com> <CAPmG0jaUz1JeRiu_cAqQXM-mAhBcTLKrmxfTu=OqcrHLBRLA+A@mail.gmail.com>
 <0EBF76CB-A350-4108-91EF-076A73932061@gmail.com> <CAPmG0jaUeisyZD6eApjaf=e3OdTaCWFDCoT_8Msc1HUadyNWug@mail.gmail.com>
 <EE95D9F3-84A2-4F45-B1FE-D54557374EF3@gmail.com> <20160707012246.3559fd0a@jupiter.sol.kaishome.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 19:46:00 -0600
Message-ID: <CAJCQCtTvzBFby+n5uV4dHYH38nuh8AS_sBLNSdQOyixeoK+QCw@mail.gmail.com>
Subject: Re: btrfs RAID 10 truncates files over 2G to 4096 bytes.
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 5:22 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

> The current implementation of RAID0 in btrfs is probably not very
> optimized. RAID0 is a special case anyways: Stripes have a defined
> width - I'm not sure what it is for btrfs, probably it's per chunk, so
> it's 1GB, maybe it's 64k **.

Stripe element (a.k.a. strip, a.k.a. md chunk) size in Btrfs is fixed at 64KiB.

>That means your data is usually not read
> from multiple disks in parallel anyways as long as requests are below
> stripe width (which is probably true for most access patterns except
> copying files) - there's no immediate performance benefit.

Most any write pattern benefits from raid0 due to less disk
contention, even if the typical file size is smaller than stripe size.
Parallelization is improved even if it's suboptimal. This is really no
different than md raid striping with a 64KiB chunk size.

On Btrfs, it might be that some workloads benefit from metadata
raid10, and others don't. I also think it's hard to estimate without
benchmarking an actual workload with metadata as raid1 vs raid10.



> So I guess, at this stage there's no big difference between RAID1 and
> RAID10 in btrfs (except maybe for large file copies), not for single
> process access patterns and neither for multi process access patterns.
> Btrfs can only benefit from RAID1 in multi process access patterns
> currently, as can btrfs RAID0 by design for usual small random access
> patterns (and maybe large sequential operations). But RAID1 with more
> than two disks and multi process access patterns is more or less equal
> to RAID10 because stripes are likely to be on different devices anyways.

I think that too would need to be benchmarked and I think it'd need to
be aged as well to see the effect of both file and block group free
space fragmentation. The devil will be in really minute details, all
you have to do is read a few weeks of XFS list stuff with people
talking about optimization or bad performance and almost always it's
not the fault of the file system. And when it is, it depends on the
kernel version as XFS has had substantial changes even over its long
career, including (somewhat) recent changes for metadata heavy
workloads.

> In conclusion: RAID1 is simpler than RAID10 and thus its less likely to
> contain flaws or bugs.

I don't know about that. I think it's about the same. All multiple
device support, except raid56, was introduced at the same time
practically from day 2. Btrfs raid1 and raid10 tolerate only exactly 1
device loss, *maybe* two if you're very lucky, so neither of them are
really scalable.


-- 
Chris Murphy
