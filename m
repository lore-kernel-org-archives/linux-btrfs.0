From: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: Re: [PATCH 01/18] btrfs: Remove u64 conversion for PAGE_CACHE_SIZE
Date: Wed, 31 Mar 2010 12:04:14 +0800
Message-ID: <4BB2C9BE.6000402@cn.fujitsu.com>
References: <4BAB56AE.5040009@cn.fujitsu.com> <20100325130230.GG6538@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100325130230.GG6538@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, Mar 25, 2010 at 08:27:26PM +0800, Miao Xie wrote:
>> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>>
>> We don't need to convert PAGE_CACHE_SIZE to u64 in bit operation.
> 
> For code like this:
> 
> u64 size = (some number that doesn't fit in 32 bits)
> 
> if (size & (PAGE_CACHE_SIZE - 1)) {
> }
> 
> The answer should be the same either way.  But if the code gets
> switched:
> 
> start = size & ~(PAGE_CACHE_SIZE - 1);
> 
> Some arches are going to get the wrong answer here.  We had a few bugs
> like this early on and I went through and casted everything to be
> consistent.  While this patch is correct, I would rather leave the casts
> to avoid subtle problems later on as the code changes.
> 
> -chris

Hello, chris

Thanks for your explain.
I got your meaning.

But at least, we should make code unify:

// with u64:
[root@localhost btrfs]# grep '((u64)PAGE_CACHE_SIZE - 1)' *
compression.c:  WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
extent_io.c:    size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
extent_io.c:    size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
extent_io.c:    size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
extent_io.c:    size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
extent_io.c:    size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
extent_io.c:    size_t start_offset = dst->start & ((u64)PAGE_CACHE_SIZE - 1);
extent_io.c:    size_t start_offset = dst->start & ((u64)PAGE_CACHE_SIZE - 1);
extent_io.c:    size_t start_offset = dst->start & ((u64)PAGE_CACHE_SIZE - 1);

// without u64:
[root@localhost btrfs]# grep '(PAGE_CACHE_SIZE - 1)' *
compression.c:                  size_t zero_offset = isize & (PAGE_CACHE_SIZE - 1);
extent_io.c:                    unsigned long offset = (*start) & (PAGE_CACHE_SIZE - 1);
extent_io.c:            size_t zero_offset = last_byte & (PAGE_CACHE_SIZE - 1);
extent_io.c:    pg_offset = i_size & (PAGE_CACHE_SIZE - 1);
extent_io.c:            block_off_start = block_start & (PAGE_CACHE_SIZE - 1);
extent_io.c:            page_offset = block_start & (PAGE_CACHE_SIZE - 1);
extent_io.c:            if ((i == 0 && (eb->start & (PAGE_CACHE_SIZE - 1))) ||
extent_io.c:                 ((eb->start + eb->len) & (PAGE_CACHE_SIZE - 1)))) {
extent_io.c:    size_t offset = start & (PAGE_CACHE_SIZE - 1);
file.c: int offset = pos & (PAGE_CACHE_SIZE - 1);
file.c: if ((pos & (PAGE_CACHE_SIZE - 1))) {
file.c: if ((pos + count) & (PAGE_CACHE_SIZE - 1)) {
file.c:         size_t offset = pos & (PAGE_CACHE_SIZE - 1);
file-item.c:            memcpy(eb_token + ((unsigned long)item & (PAGE_CACHE_SIZE - 1)),
inode.c:                offset = start & (PAGE_CACHE_SIZE - 1);
inode.c:                                (PAGE_CACHE_SIZE - 1);
inode.c:                        ~(PAGE_CACHE_SIZE - 1);
inode.c:        if ((end & (PAGE_CACHE_SIZE - 1)) == 0)

Thanks
Zhaolei

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


