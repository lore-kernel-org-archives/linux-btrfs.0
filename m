Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52931 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbaE0TY4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 15:24:56 -0400
Message-ID: <5384E728.3070403@fb.com>
Date: Tue, 27 May 2014 15:27:36 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>,
        <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: 3.15.0-rc5: now sync and mount are hung on call_rwsem_down_write_failed
References: <20140522090921.GA12037@merlins.org> <20140522131528.GB22952@merlins.org> <pan$ed92c$6d9566f6$dd2041b0$f135597e@cox.net> <20140523002243.GE12312@merlins.org> <20140523141722.GA11991@merlins.org> <537FAE91.20308@fb.com> <20140523231337.GC12384@merlins.org>
In-Reply-To: <20140523231337.GC12384@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/23/2014 07:13 PM, Marc MERLIN wrote:
> On Fri, May 23, 2014 at 04:24:49PM -0400, Chris Mason wrote:
>>> I was able to kill btrfs send and receive, but mencoder is very hung, and
>>> sync does not finish either:
>>> 10654 merlin   sync                        sync_inodes_sb
>>> 17191 merlin   sync                        call_rwsem_down_read_failed
>>>
>>> I'm not posting the sysrq-w every time, but I have it available if needed.
>>
>> Hi Marc,
>>
>> Can I have the sysrq-w from this one if it's still available?
> 
> Argh, just found out that the bug caused none of the 2 copies to ever
> be committed to disk (including an ext4 partition), and the remote
> syslog lost too much for it to be useful.
> 
> What's more weird is the previous one, where I was able to copy the
> syslog data that never got committed to disk but was still in the page
> cache to another machine, I just realized that this one is missing the
> beginning (it starts at cpu #4).
> 
> So it looks like the only complete one I have right now is
> https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/btrfs-hang.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=trVl686QjTewKFAeRvMI4%2BQqLBCr36hUPGAiCv6xEMk%3D%0A&s=8b775a694311d54d110d686f86531ca5ce2db479b2aa5966d6056ebf173825b8
> 
> If you need more, please let me know, and I'll make sure that I save
> that very carefully next time.

It's not 100% clear what is going on here.  You have a number of procs
waiting for page locks, one of which is trying to read in your free
space cache.

Was this one of your machines with metadata corruption?  More traces
definitely help.

-chris

