Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:49092 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753644AbcKYM0S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 07:26:18 -0500
Date: Fri, 25 Nov 2016 17:25:56 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mount option nodatacow for VMs on SSD?
Message-ID: <20161125172556.463a7796@natsu>
In-Reply-To: <pan$c85ad$dae9ebf5$a0482059$7c135fb1@cox.net>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
        <pan$c85ad$dae9ebf5$a0482059$7c135fb1@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Nov 2016 12:01:37 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Obviously this can be a HUGE problem on spinning rust due to its seek times,
> a problem zero-seek-time ssds don't have

They are not strictly zero seek time either. Sure you don't have the issue of
moving the physical head around, but still, sequential reads are way faster
even on SSDs, compared to random reads. Somewhat typical result for a
consumer SSD:

           Sequential Read :   382.301 MB/s
          Sequential Write :   315.124 MB/s
         Random Read 512KB :   261.751 MB/s
        Random Write 512KB :   334.615 MB/s
    Random Read 4KB (QD=1) :    19.859 MB/s [  4848.5 IOPS]
   Random Write 4KB (QD=1) :    61.794 MB/s [ 15086.3 IOPS]
   Random Read 4KB (QD=32) :   132.415 MB/s [ 32327.9 IOPS]
  Random Write 4KB (QD=32) :   203.051 MB/s [ 49573.0 IOPS]

If you have tons of 4K fragments, reading them in can go as low as 20 MB/sec,
compared to 382 MB/sec if they were all in one piece.

-- 
With respect,
Roman
