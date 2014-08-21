Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbaHUS4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 14:56:53 -0400
Message-ID: <53F640F1.1010104@redhat.com>
Date: Thu, 21 Aug 2014 13:56:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: marvin24@gmx.de
Subject: Re: [PATCH] btrfs-progs: init uninitialized output buf for btrfs-restore
References: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com> <53F63D8F.2080400@redhat.com>
In-Reply-To: <53F63D8F.2080400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/21/14, 1:42 PM, Eric Sandeen wrote:
> On 8/20/14, 10:35 PM, Gui Hecheng wrote:
>> A memory problem reported by valgrind as follows:
>> 	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
>> When running:
>> 	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup
>>
>> Because the output buf size is alloced with malloc, but the length of
>> output data is shorter than the sizeof(buf), so valgrind report
>> uninitialised byte(s).
>> We could use calloc to repalce malloc and clear this WARNING away.
> 
> It clears the valgrind error away, but does it hide a real bug?

Maybe the relevant question for Marc is - did you get decompression
errors during restore?  if so then I guess it all makes sense, and
the proposed patch seems sane after all, sorry.

-Eric

