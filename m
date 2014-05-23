Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2194 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbaEWUV6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 16:21:58 -0400
Message-ID: <537FAE91.20308@fb.com>
Date: Fri, 23 May 2014 16:24:49 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Duncan <1i5t5.duncan@cox.net>
CC: <linux-btrfs@vger.kernel.org>, <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: 3.15.0-rc5: now sync and mount are hung on call_rwsem_down_write_failed
References: <20140522090921.GA12037@merlins.org> <20140522131528.GB22952@merlins.org> <pan$ed92c$6d9566f6$dd2041b0$f135597e@cox.net> <20140523002243.GE12312@merlins.org> <20140523141722.GA11991@merlins.org>
In-Reply-To: <20140523141722.GA11991@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2014 10:17 AM, Marc MERLIN wrote:
> I had btrfs send/receive running.
> 
> Plugging the power in caused laptop-mode to remount my root partition.
> 
> That hung, and in turn all of btrfs hung too.
> 
>  7668 root     btrfs send home_ro.20140523 -
>  7669 root     btrfs receive /mnt/btrfs_po sleep_on_page
> 12118 root     mount /dev/mapper/cryptroot call_rwsem_down_write_failed
> 10678 merlin   mencoder -passlogfile dsc04 sleep_on_page
> 
> Clearly, it takes very little for 3.15rc5 to deadlock :(
> 
> (I wasn't running balance or snapshot this time)
> 
> I was able to kill btrfs send and receive, but mencoder is very hung, and
> sync does not finish either:
> 10654 merlin   sync                        sync_inodes_sb
> 17191 merlin   sync                        call_rwsem_down_read_failed
> 
> I'm not posting the sysrq-w every time, but I have it available if needed.

Hi Marc,

Can I have the sysrq-w from this one if it's still available?

-chris

