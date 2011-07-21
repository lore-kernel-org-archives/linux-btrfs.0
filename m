From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Thu, 21 Jul 2011 12:54:02 +0800
Message-ID: <4E27B0EA.2070601@cn.fujitsu.com>
References: <1311096438-sup-1263@shiny> <1311182478-sup-9986@shiny> <1311187835-sup-7598@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311187835-sup-7598@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Excerpts from Chris Mason's message of 2011-07-20 13:21:47 -0400:
>> Excerpts from Chris Mason's message of 2011-07-19 13:30:22 -0400:
>>> Hi everyone,
>>>
>>> I've pushed out a new integration-test branch, and it includes a new
>>> reader/writer locking scheme for the btree locks.
>>>
>>> We've seen a number of benchmarks dominated by contention on the root
>>> node lock.  This changes our locks into a simple reader/writer lock.
>>> They are based on mutexes so that we still take advantage of the mutex
>>> adaptive spins for write locks (rwsemaphores were much slower).
>>>
>>> I'm also sending the individual commits, please do take a look.
>>
>> Hi everyone,
>>
>> I just rebased Josef's enospc fixes into integration-test, it should fix
>> the warnings in extent-tree.c
> 
> And one more rebase to fix the x86-32 problems.
> 

We can simply use page_address() in this macro:

#define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)             \
static inline u##bits btrfs_##name(struct extent_buffer *eb)            \
{                                                                       \
        type *p = kmap_atomic(eb->first_page, KM_USER0);                \
        u##bits res = le##bits##_to_cpu(p->member);                     \
        kunmap_atomic(p, KM_USER0);                                     \
        return res;                                                     \
}
