Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43737 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425215AbeE1PyD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:03 -0400
Date: Mon, 28 May 2018 13:50:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs: lzo: Add header length check to avoid slab
 out of bounds access
Message-ID: <20180528115050.GU6649@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180521051927.3715-1-wqu@suse.com>
 <20180521051927.3715-4-wqu@suse.com>
 <20180522150636.GN6649@twin.jikos.cz>
 <34f13170-f2cb-4efe-7f11-72ce7aa5c622@suse.de>
 <20180524164313.GH6649@twin.jikos.cz>
 <7fbc7ed1-08b1-c54a-c9d9-b5f4ad759821@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7fbc7ed1-08b1-c54a-c9d9-b5f4ad759821@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2018 at 09:31:30AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年05月25日 00:43, David Sterba wrote:
> > On Wed, May 23, 2018 at 07:38:28AM +0800, Qu Wenruo wrote:
> >>>> --- a/fs/btrfs/lzo.c
> >>>> +++ b/fs/btrfs/lzo.c
> >>>> @@ -281,6 +281,7 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
> >>>>  	unsigned long working_bytes;
> >>>>  	size_t in_len;
> >>>>  	size_t out_len;
> >>>> +	size_t max_segment_len = lzo1x_worst_compress(PAGE_SIZE);
> >>>
> >>> The value is a compile-time constant, it does not need to be stored in a
> >>> variable.
> >>
> >> Just to save some long lines, as it's used several times.
> > 
> > My concern is about the eventual stack consumption by the variable. I
> > haven't measured that as the stack-bloat-script is now somehow broken so
> > I'm basing this on my previous evaluations. The long term plan is to
> > remove unnecessary variables or at least help the compiler to optimize
> > them out, every few bytes help and we hope for the cumulative effect.
> 
> I think for such constant value, compiler should be clear enough to
> avoid the usage of stack.
> 
> And in fact it indeed avoids the usage of stack memory, even without
> const prefix.
> All operation related to @max_segment_len are using immediate number 4419.
> (Result is from gcc 8.1)
> ------
> lzo_decompress_bio:
> 1:	call	__fentry__
> 	pushq	%r15	#
> 	movq	%rdi, %r15	# ws, ws
> 	movq	%rsi, %rdi	# cb, cb
> 	pushq	%r14	#
> 	pushq	%r13	#
> 	pushq	%r12	#
> 	pushq	%rbp	#
> 	pushq	%rbx	#
> 	addq	$-128, %rsp	#,
> # fs/btrfs//lzo.c:305: 	u64 disk_start = cb->start;
> 	movq	24(%rdi), %rcx	# cb_63(D)->start, disk_start
> # fs/btrfs//lzo.c:283: {
> 	movq	%rsi, 32(%rsp)	# cb, %sfp
> 	movq	%gs:40, %rax	# MEM[(<address-space-2> long unsigned int *)40B], tmp197
> 	movq	%rax, 120(%rsp)	# tmp197, D.32453
> 	xorl	%eax, %eax	# tmp197
> # fs/btrfs//lzo.c:288: 	size_t srclen = cb->compressed_len;
> 	movq	40(%rsi), %rax	# cb_63(D)->compressed_len, srclen
> # fs/btrfs//lzo.c:304: 	struct page **pages_in = cb->compressed_pages;
> 	movq	8(%rsi), %rsi	# cb_63(D)->compressed_pages, pages_in
> # fs/btrfs//lzo.c:305: 	u64 disk_start = cb->start;
> 	movq	%rcx, 40(%rsp)	# disk_start, %sfp
> # ./include/linux/mm.h:1098: 	return page_to_virt(page);
> 	movabsq	$-131941395333120, %rcx	#, tmp154
> # fs/btrfs//lzo.c:289: 	unsigned long total_pages_in =
> DIV_ROUND_UP(srclen, PAGE_SIZE);
> 	leaq	4095(%rax), %rdx	#, tmp147
> # ./include/linux/mm.h:1098: 	return page_to_virt(page);
> 	movq	(%rsi), %rbp	# *pages_in_66, tmp148
> # fs/btrfs//lzo.c:304: 	struct page **pages_in = cb->compressed_pages;
> 	movq	%rsi, 88(%rsp)	# pages_in, %sfp
> # fs/btrfs//lzo.c:317: 	if (tot_len > min_t(size_t,
> BTRFS_MAX_COMPRESSED, srclen) ||
> 	movl	$131072, %esi	#, tmp156
> # fs/btrfs//lzo.c:289: 	unsigned long total_pages_in =
> DIV_ROUND_UP(srclen, PAGE_SIZE);
> 	shrq	$12, %rdx	#, tmp147
> 	movq	%rdx, 80(%rsp)	# tmp147, %sfp
> # fs/btrfs//lzo.c:306: 	struct bio *orig_bio = cb->orig_bio;
> 	movq	72(%rdi), %rdx	# cb_63(D)->orig_bio, orig_bio
> 	movq	%rdx, 24(%rsp)	# orig_bio, %sfp
> # ./include/linux/mm.h:1098: 	return page_to_virt(page);
> 	movabsq	$24189255811072, %rdx	#, tmp149
> 	addq	%rdx, %rbp	# tmp149, tmp148
> 	sarq	$6, %rbp	#, tmp152
> 	salq	$12, %rbp	#, tmp153
> 	addq	%rcx, %rbp	# tmp154, data_in
> # fs/btrfs//lzo.c:317: 	if (tot_len > min_t(size_t,
> BTRFS_MAX_COMPRESSED, srclen) ||
> 	cmpq	$131072, %rax	#, srclen
> ------
> 
> My question is, if this is a little overkilled for us human to do all
> the work which should be done by compiler.

It depends, if we know the value is a constant and want to give it a
symbolic name, then it's ok to add the variable. That's IMO not an
overkill but a good coding practice. If there's no const but there are
no writes to the variable, the compiler can assume it's a constant and
treat it like that. But this requires additional logic.

> > The replacement by local variable sort of does not need to be in this
> > patch as it's not used for the header length check itself.
> > 
> >>>> @@ -294,6 +295,18 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
> >>>>  
> >>>>  	data_in = kmap(pages_in[0]);
> >>>>  	tot_len = read_compress_length(data_in);
> >>>> +	/*
> >>>> +	 * Compressed data header check.
> >>>> +	 *
> >>>> +	 * The real compressed size can't exceed extent length, and all pages
> >>>> +	 * should be used (a full pending page is not possible).
> >>>> +	 * If this happens it means the compressed extent is corrupted.
> >>>> +	 */
> >>>> +	if (tot_len > min_t(size_t, BTRFS_MAX_COMPRESSED, srclen) ||
> >>>> +	    tot_len < srclen - PAGE_SIZE) {
> >>>
> >>> All such conditions can be put into unlikely() as this is an error
> >>> handling shortcut.
> >>
> >> I'm OK to put it into unlikely().
> >>
> >> I'll update this in next version.
> > 
> > I don't see the unlikely() in the most recent version but after some
> > considerations, I don't think it's needed. I'd rather look at the final
> > assembly if the compiler is smart enough to recognize the pattern.
> 
> With .s from gcc 8.1 attached.
> Both unlikely() added and without unlikely().
> 
> There is some difference, however I can't really tell.

Typically the diff between the version shos that a part of the function
is moved to the end so the unlikely code is not in the sequence of
instructions.

> > Adding likely/unlikely without some proof is not welcome in general,
> > though in this case it's the allowed "jump to error handling".
> 
> Forgot to mention that, IIRC years ago someone told me not to use
> likely/unlikely unless really needed.

And the jump to error handling code, when the condition cannot be
predicted during compile time, is one such use. The statically
predictable conditions are eg. NULL pointer checks.

> And in my understanding, such "optimization" doesn't really make much
> sense since the branch prediction implemented by hardware would have
> larger impact.

I've asked about that some CPU people if this does have an impact and
the answer is yes. The details are about instruction stream parsing and
pipelining etc, but on that level, if the likely instruction is in the
buffer it's less work compared to fetching unparsed instructions a few
bytes later.

The compression code can be optimized more and split to hot and cold
paths as this is in-memory processing and potentially called many times.
Here the error handling is the cold path, and as it's catching possible
but highly unlikely case, moving that out of the hot path is still worth
doing.
