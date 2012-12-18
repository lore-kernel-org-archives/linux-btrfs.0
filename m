Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59157 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab2LRW04 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 17:26:56 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Tue, 18 Dec 2012 15:26:55 -0700
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id ABD2F19D8042
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 15:26:52 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qBIMQpYW229968
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 15:26:52 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qBIMQpYf031189
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 15:26:51 -0700
Message-ID: <50D0EDAA.3090202@linux.vnet.ibm.com>
Date: Tue, 18 Dec 2012 14:26:50 -0800
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org, cmm@linux.vnet.ibm.com
Subject: Re: [PATCH] [RFC v2] Btrfs: Subpagesize blocksize (WIP).
References: <1355814805-13935-1-git-send-email-clinew@linux.vnet.ibm.com> <20121218073050.GA19332@liubo.cn.oracle.com> <50D02E0A.8080505@cn.fujitsu.com>
In-Reply-To: <50D02E0A.8080505@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/18/2012 12:49 AM, Miao Xie wrote:

> On tue, 18 Dec 2012 15:30:51 +0800, Liu Bo wrote:
>> On Mon, Dec 17, 2012 at 11:13:25PM -0800, clinew@linux.vnet.ibm.com wrote:
>>> From: Wade Cline<clinew@linux.vnet.ibm.com>
>>>
>>> v1 ->  v2:
>>> - Added Signed-off-by tag (it's kind of important).
>>>
>>> This patch is only an RFC. My internship is ending and I was hoping
>>> to get some feedback and incorporate any suggestions people may
>>> have before my internship ends along with life as we know it (this
>>> Friday).
>>>
>>> The filesystem should mount/umount properly but tends towards the
>>> explosive side when writes start happening. My current focus is on
>>> checksumming issues and also an error when releasing extent buffers
>>> when creating a large file with 'dd'... and probably any other
>>> method. There's still a significant amount of work that needs to be
>>> done before this should be incorporated into mainline.
>>>
>>> A couple of notes:
>>>      - Based off of Josef's btrfs-next branch, commit
>>>        8d089a86e45b34d7bc534d955e9d8543609f7e42
>>>      - C99-style comments are "meta-comments" where I'd like more
>>>        feedback; they aren't permanent but make 'checkpatch' moan.
>>>      - extent_buffer allocation and freeing need their code paths
>>>        merged; they're currently in separate functions and are both
>>>        very ugly.
>>>      - The patch itself will eventually need to be broken down
>>>        into smaller pieces if at all possible...
>>
>> Could you please first elaborate why we need this subpagesize stuff and
>> any user case in this patch's commit log?
>> Or Am I missing something?
>
> It is used on the machines on which the page size is larger than 4KB (Such as powerpc)
>
> Thanks
> Miao

Yeah. Basically, if we create a btrfs filesystem with a 4k blocksize
then that filesystem is incompatible with architectures such as PowerPC
and MIPS which have a page size larger than 4k.

-Wade

