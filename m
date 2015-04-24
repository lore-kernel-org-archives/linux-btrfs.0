Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35486 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965409AbbDXQJN (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 24 Apr 2015 12:09:13 -0400
Message-ID: <553A6A98.4070309@suse.com>
Date: Fri, 24 Apr 2015 17:08:56 +0100
From: Filipe Manana <fdmanana@suse.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com>	<pan.2015.04.23.12.16.21@googlemail.com> <5538E6C7.9050201@suse.com>	<pan.2015.04.23.13.22.23@googlemail.com> <5538F70C.5040004@suse.com> <pan.2015.04.23.13.53.22@googlemail.com>
In-Reply-To: <pan.2015.04.23.13.53.22@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/23/2015 02:53 PM, Holger Hoffstätte wrote:
> On Thu, 23 Apr 2015 14:43:40 +0100, Filipe Manana wrote:
> 
>> I don't think a lock followed by unlock without nothing in between (be
>> it a spinlock, mutex, or any other kind of lock) will be seen by the
>> compiler as a nop. Pretty sure I've seen this pattern being done in the
> 
> No, I didn't say they would - that would be wrong. I just found it odd,
> that's all.

For reference, you have plenty of example in the kernel source tree:

$ find . -name '*.c' | xargs pcregrep --line-offsets -nrM '^\s*spin_lock.*\n^\s*spin_unlock'
(...)
./fs/ext4/balloc.c:644:0,68
(...)
./mm/truncate.c:458:0,51
(...)

$ cat ./fs/ext4/balloc.c | head -646 | tail -4
	if (!(*errp) && (flags & EXT4_MB_DELALLOC_RESERVED)) {
		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
		dquot_alloc_block_nofail(inode,

$ cat ./mm/truncate.c | head -460 | tail -9
		/*
		 * As truncation uses a lockless tree lookup, cycle
		 * the tree lock to make sure any ongoing tree
		 * modification that does not see AS_EXITING is
		 * completed before starting the final truncate.
		 */
		spin_lock_irq(&mapping->tree_lock);
		spin_unlock_irq(&mapping->tree_lock);


> 
>> kernel and in many other places as mechanism to wait for something.
> 
> I also completely forgot that spinlocks disable preemption, since
> otherwise nothing would really work. That's the real reason why
> any of this works. Well, that and the refcount==2 thing.
> 
> Cool! Thanks!
> Holger
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
