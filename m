Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:13875 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbcBQGGE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 01:06:04 -0500
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 843B8AC02D1
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 14:55:37 +0900 (JST)
Subject: Re: [PATCH] btrfs: Avoid BUG_ON()s because of ENOMEM caused by
 kmalloc() failure
To: <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56C16441.5030000@jp.fujitsu.com>
 <20160215175333.GO4374@twin.jikos.cz>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56C40B0F.3090209@jp.fujitsu.com>
Date: Wed, 17 Feb 2016 14:54:23 +0900
MIME-Version: 1.0
In-Reply-To: <20160215175333.GO4374@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/02/16 2:53, David Sterba wrote:
> On Mon, Feb 15, 2016 at 02:38:09PM +0900, Satoru Takeuchi wrote:
>> There are some BUG_ON()'s after kmalloc() as follows.
>>
>> =====
>> foo = kmalloc();
>> BUG_ON(!foo);	/* -ENOMEM case */
>> =====
>>
>> A Docker + memory cgroup user hit these BUG_ON()s.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=112101
>>
>> Since it's very hard to handle these ENOMEMs properly,
>> preventing these kmalloc() failures to avoid these
>> BUG_ON()s for now, are a bit better than the current
>> implementation anyway.
>
> Beware that the NOFAIL semantics is can cause deadlocks if it's on the
> critical writeback path or and can be reentered from itself through the
> reclaim. Unless you're sure that this is not the case, please do not add
> them just because it would seemingly fix the allocation failures.

About the all cases I changed, kmalloc()s can block
since gfp_flags_allow_blocking() are true. Then no locks
are acquired here and deadlocks don't happen.

Am I missing something?

>
> In the docker example, the memory is limited by cgroups so the NOFAIL
> mode can exhaust all reserves and just loop endlessly waiting for the
> OOM killer to get some memory or just waiting without any chance to
> progress.

I consider triggering OOM killer and killing processes
in a cgroup are better than killing whole system.

About the possibility of endless loop, there are many
such problems in the whole kernel. Of course it can be
said to Btrfs.

==========================================
$ grep -rnH __GFP_NOFAIL fs/btrfs/
fs/btrfs/extent-tree.c:5970: GFP_NOFS | __GFP_NOFAIL);
fs/btrfs/extent-tree.c:6043: bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
fs/btrfs/extent_io.c:4643: eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
fs/btrfs/extent_io.c:4909: p = find_or_create_page(mapping, index, GFP_NOFS|__GFP_NOFAIL);
==========================================

I understand fixing these problems cooperate with
memory cgroup guys is the best in the long run.
However, I consider bypassing this problem for now
is better than the current implementation.

Thanks,
Satoru

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
