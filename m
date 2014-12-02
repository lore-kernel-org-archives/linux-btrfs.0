Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58105 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbaLBN2e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 08:28:34 -0500
Date: Tue, 2 Dec 2014 08:28:22 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v4 00/10] Implement device scrub/replace for RAID56
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1417526902.21136.1@mail.thefacebook.com>
In-Reply-To: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com>
References: <1417523971-15553-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Dec 2, 2014 at 7:39 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> This patchset implement the device scrub/replace function for RAID56, 
> the
> most implementation of the common data is similar to the other RAID 
> type.
> The differentia or difficulty is the parity process. The basic idea 
> is reading
> and check the data which has checksum out of the raid56 stripe lock, 
> if the
> data is right, then lock the raid56 stripe, read out the other data 
> in the
> same stripe, if no IO error happens, calculate the parity and check 
> the
> original one, if the original parity is right, the scrub parity 
> passes.
> or write out the new one. But if the common data(not parity) that we 
> read out
> is wrong, we will try to recover it, and then check and repair the 
> parity.
> 
> And in order to avoid making the code more and more complex, we copy 
> some
> code of common data process for the parity, the cleanup work is in my
> TODO list.
> 
> We have done some test, the patchset worked well. Of course, more 
> tests
> are welcome. If you are interesting to use it or test it, you can pull
> the patchset from
> 
>   https://github.com/miaoxie/linux-btrfs.git raid56-scrub-replace
> 
> Changelog v3 -> v4:
> - Fix the problem that the scrub's raid bio was cached, which was 
> reported
>   by Chris.
> - Remove the 10st patch, the deadlock that was described in that 
> patch doesn't
>   exist on the current kernel.
> - Rebase the patchset to the top of integration branch

Thanks, I'll try this today.  I need to rebase in a new version of the 
RCU patches, can you please cook one on top of v3.18-rc6 instead?

-chris

