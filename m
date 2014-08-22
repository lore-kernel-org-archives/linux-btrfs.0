Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbaHVPTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 11:19:40 -0400
Message-ID: <53F75F87.4050302@redhat.com>
Date: Fri, 22 Aug 2014 10:19:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: init uninitialized output buf for btrfs-restore
References: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com> <53F63D8F.2080400@redhat.com> <53F640F1.1010104@redhat.com> <2820069.ALay9nml0k@fb07-iapwap2>
In-Reply-To: <2820069.ALay9nml0k@fb07-iapwap2>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/22/14, 2:35 AM, Marc Dietrich wrote:
> Hi Eric,
> 
> Am Donnerstag, 21. August 2014, 13:56:49 schrieb Eric Sandeen:
>> On 8/21/14, 1:42 PM, Eric Sandeen wrote:
>>> On 8/20/14, 10:35 PM, Gui Hecheng wrote:
>>>> A memory problem reported by valgrind as follows:
>>>> 	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
>>>>
>>>> When running:
>>>> 	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup
>>>>
>>>> Because the output buf size is alloced with malloc, but the length of
>>>> output data is shorter than the sizeof(buf), so valgrind report
>>>> uninitialised byte(s).
>>>> We could use calloc to repalce malloc and clear this WARNING away.
>>>
>>> It clears the valgrind error away, but does it hide a real bug?
>>
>> Maybe the relevant question for Marc is - did you get decompression
>> errors during restore?  if so then I guess it all makes sense, and
>> the proposed patch seems sane after all, sorry.
> 
> I use lzo and yes, I got decompression errors.

Ok, ignore me then, I'm sorry - it all makes sense, Gui's patch
included.  I didn't have my head on straight.

Thanks,
-Eric

