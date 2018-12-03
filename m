Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B119C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 20:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F06520848
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 20:04:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F06520848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bouton.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbeLCUEf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 15:04:35 -0500
Received: from ns.bouton.name ([109.74.195.142]:43560 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbeLCUEf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Dec 2018 15:04:35 -0500
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2018 15:04:33 EST
Received: from [192.168.0.47] (adsl.bouton.name [82.234.193.23])
        by mail.bouton.name (Postfix) with ESMTP id C92FDB849;
        Mon,  3 Dec 2018 20:56:08 +0100 (CET)
Subject: Re: BTRFS Mount Delay Time Graph
To:     "Wilson, Ellis" <ellisw@panasas.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
From:   Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <4746e8ba-b20c-01e2-379e-b76f0d2ab5a7@bouton.name>
Date:   Mon, 3 Dec 2018 20:56:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Le 03/12/2018 à 19:20, Wilson, Ellis a écrit :
> Hi all,
>
> Many months ago I promised to graph how long it took to mount a BTRFS 
> filesystem as it grows.  I finally had (made) time for this, and the 
> attached is the result of my testing.  The image is a fairly 
> self-explanatory graph, and the raw data is also attached in 
> comma-delimited format for the more curious.  The columns are: 
> Filesystem Size (GB), Mount Time 1 (s), Mount Time 2 (s), Mount Time 3 (s).
>
> Experimental setup:
> - System:
> Linux pgh-sa-1-2 4.20.0-rc4-1.g1ac69b7-default #1 SMP PREEMPT Mon Nov 26 
> 06:22:42 UTC 2018 (1ac69b7) x86_64 x86_64 x86_64 GNU/Linux
> - 6-drive RAID0 (mdraid, 8MB chunks) array of 12TB enterprise drives.
> - 3 unmount/mount cycles performed in between adding another 250GB of data
> - 250GB of data added each time in the form of 25x10GB files in their 
> own directory.  Files generated in parallel each epoch (25 at the same 
> time, with a 1MB record size).
> - 240 repetitions of this performed (to collect timings in increments of 
> 250GB between a 0GB and 60TB filesystem)
> - Normal "time" command used to measure time to mount.  "Real" time used 
> of the timings reported from time.
> - Mount:
> /dev/md0 on /btrfs type btrfs 
> (rw,relatime,space_cache=v2,subvolid=5,subvol=/)
>
> At 60TB, we take 30s to mount the filesystem, which is actually not as 
> bad as I originally thought it would be (perhaps as a result of using 
> RAID0 via mdraid rather than native RAID0 in BTRFS).  However, I am open 
> to comment if folks more intimately familiar with BTRFS think this is 
> due to the very large files I've used.  I can redo the test with much 
> more realistic data if people have legitimate reason to think it will 
> drastically change the result.

We are hosting some large BTRFS filesystems on Ceph (RBD used by
QEMU/KVM). I believe the delay is heavily linked to the number of files
(I didn't check if snapshots matter and I suspect it does but not as
much as the number of "original" files at least if you don't heavily
modify existing files but mostly create new ones as we do).
As an example, we have a filesystem with 20TB used space with 4
subvolumes hosting multi millions files/directories (probably 10-20
millions total I didn't check the exact number recently as simply
counting files is a very long process) and 40 snapshots for each volume.
Mount takes about 15 minutes.
We have virtual machines that we don't reboot as often as we would like
because of these slow mount times.

If you want to study this, you could :
- graph the delay for various individual file sizes (instead of 25x10GB,
create 2 500 x 100MB and 250 000 x 1MB files between each run and
compare to the original result)
- graph the delay vs the number of snapshots (probably starting with a
large number of files in the initial subvolume to start with a non
trivial mount delay)
You may want to study the impact of the differences between snapshots by
comparing snapshoting without modifications and snapshots made at
various stages of your suvolume growth.

Note : recently I tried upgrading from 4.9 to 4.14 kernels, various
tuning of the io queue (switching between classic io-schedulers and
blk-mq ones in the virtual machines) and BTRFS mount options
(space_cache=v2,ssd_spread) but there wasn't any measurable improvement
in mount time (I managed to reduce the mount of IO requests by half on
one server in production though although more tests are needed to
isolate the cause).
I didn't expect much for the mount times, it seems to me that mount is
mostly constrained by the BTRFS on disk structures needed at mount time
and how the filesystem reads them (for example it doesn't benefit at all
from large IO queue depths which probably means that each read depends
on previous ones which prevents io-schedulers from optimizing anything).

Best regards,

Lionel
