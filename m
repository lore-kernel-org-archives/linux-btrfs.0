Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28996 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3JGDPM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Oct 2013 23:15:12 -0400
Message-ID: <525228F9.9070702@oracle.com>
Date: Mon, 07 Oct 2013 11:22:33 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: Wang Shilong <wangshilong1991@gmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com> <525220DC.2030403@oracle.com> <525223EC.9070800@cn.fujitsu.com>
In-Reply-To: <525223EC.9070800@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/07/2013 11:01 AM, Wang Shilong wrote:
> On 10/07/2013 10:47 AM, Anand Jain wrote:
>>
>>
>>> If we want to speed up this progress, i think we can split it into two parts:
>>>
>>> 1. First to search inline extent_data
>>> 2. Secondly search in extent tree to calculate (extent refs=1)
>>>
>>> This will avoid n*n rather than n+n which is better¡­
>>    (sorry for delay in reply, I was on vacation).
>>
>>    Thanks for what might help. I was kind of expecting
>>    this when preliminary patch was sent before. Let me
>>    try what you suggest and send out v3.
>>
>>    I was also thinking if this should be inside kernel
>>    facilitated by a new ioctl? so that we avoid number
>>    of search ioctl thats required.
> Yeah, adding another ioctl maybe help. Anyway, there is another question.
> Did we need to consider metadata into subvolume's sole size?
> 
> Personaly, the answer is yes. Considering a subvolume is filled with a lot
> of empty files, but we get subvolume's sole size *0*.


 yes. Will consider for an update patch later.


Thanks, Anand
