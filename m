Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35472 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbJEEtz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 00:49:55 -0400
Received: by lackq9 with SMTP id kq9so10338045lac.2
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 21:49:54 -0700 (PDT)
Subject: Re: raid5 + HDFS
To: Martin Tippmann <martin.tippmann@gmail.com>
References: <560F0014.9020905@sics.se>
 <CABL_Pd8q=GAAHOXXOfKRbQanjhumaAGDOGrYBo33cKU5CGFcTw@mail.gmail.com>
 <CAHT4m=XMsr=o0hVCXohi-cT=51qnB0mR_pK8108rhBQ1uQ_RBA@mail.gmail.com>
 <560FEB23.4040004@sics.se>
 <CABL_Pd8Dag2toHtn2_uSkotZoLPktaC=TOZkLiPNjQDevTRcEw@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Jim Dowling <jdowling@sics.se>
Message-ID: <5612016F.3040206@sics.se>
Date: Mon, 5 Oct 2015 06:49:51 +0200
MIME-Version: 1.0
In-Reply-To: <CABL_Pd8Dag2toHtn2_uSkotZoLPktaC=TOZkLiPNjQDevTRcEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2015-10-05 00:00, Martin Tippmann wrote:
> 2015-10-03 16:50 GMT+02:00 Jim Dowling <jdowling@sics.se 
> <mailto:jdowling@sics.se>>:
>
>     As you point out, hdfs does its own checksumming of blocks, which
>     is needed as blocks are transferred over the network. So, yes it
>     is double checksumming if you will.
>
>     We are keeping the data node as it is. The only change needed will
>     be to identify a block device as an "archive" device or a normal
>     device. We're interested in archive devices for this work.
>     The bigger picture is that Apache HDFS are going towards striping
>     blocks over different data nodes, losing data locality. We are
>     investigating  btrfs/raid5 for archived data. It's workload would
>     be much lower
>     than standard.
>
>
> Hi, thanks for the clarification!
>
> [snip]
>
>     So the idea is to erasure code twice, checksum twice. Overall
>     overhead will be about 50%, half of this for raid5, half hdfs
>     erasure coding.
>     Hypothesis: For cold storage data with normal at most one active
>     job per data node, jobs will read/write data faster, improving
>     performance, particularly over 10GbE
>
>
> btrfs RAID5 should do the job - I don't think the checksumming is 
> really a problem as it's CRC32C that modern Intel CPUs provide an 
> instruction for.
>
> If the performance is not as great you could try doing btrfs on top of 
> mdraid RAID5 - mdraid should be more optimized than btrfs at that this 
> point. If you don't need btrfs snapshots and subvolumes you could 
> implement the HDFS snapshotting using the upcoming XFS reflink support 
> - that provides CoW semantics - should be working with HDFS blocks if 
> you cp --reflink them for Snapshots.
>
> From numbers that got posted here a while ago mdraid + XFS is at the 
> moment are quite bit faster than btrfs - XFS provides Metadata 
> checksumming (no duplication through) so you could spare at least the 
> double checksumming of data. However using mdraid has some caveats as 
> it's able to grow or shrink once configured.
>
> HTH
> Martin
>
Thanks for the tips Martin. We have a bit more research to do before we 
get started.
