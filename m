From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090206: kernel BUG at mm/slub.c:1132
Date: Mon, 9 Feb 2009 16:44:20 +0300
Message-ID: <a4423d670902090544g7b7dbe9aj415141c46d1fc95f@mail.gmail.com>
References: <a4423d670902060710m4919f6d6p1ffae13859c891be@mail.gmail.com>
	 <1233934630.17551.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1233934630.17551.1.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/2/6 Chris Mason <chris.mason@oracle.com>:
> On Fri, 2009-02-06 at 18:10 +0300, Alexander Beregalov wrote:
>> Hi
>>
>> I run dbench on btrfs, which is on file on xfs
>>
>> btrfs: disabling barriers on dev /dev/loop/0
>> ------------[ cut here ]------------
>> kernel BUG at mm/slub.c:1132!
>> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> last sysfs file: /sys/kernel/uevent_seqnum
>
> Btrfs hammers on slab caches quite a lot, can you reproduce this without
> loop or without btrfs?
Hi Chris

No, I can not reproduce it without loop.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
