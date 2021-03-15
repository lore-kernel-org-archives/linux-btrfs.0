Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24A9C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Mar 2021 17:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F33E64E04
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Mar 2021 17:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhCORhN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:37:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:53154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236285AbhCORgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Mar 2021 13:36:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35D55AE8F;
        Mon, 15 Mar 2021 17:36:38 +0000 (UTC)
Subject: Re: [PATCH] [PATCH] mm, slub: enable slub_debug static key when
 creating cache with explicit debug flags
To:     paulmck@kernel.org
Cc:     David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Oliver Glitta <glittao@gmail.com>
References: <20210315153415.24404-1-vbabka@suse.cz>
 <2d80f81a-ed85-a36f-6527-b75da3ae209e@google.com>
 <e723d919-222a-0675-5aae-44dfe1ce005f@suse.cz>
 <20210315173207.GN2696@paulmck-ThinkPad-P72>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <8c4f3385-e935-8363-c6bd-ffe6b8c2d6c4@suse.cz>
Date:   Mon, 15 Mar 2021 18:36:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210315173207.GN2696@paulmck-ThinkPad-P72>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/15/21 6:32 PM, Paul E. McKenney wrote:
> On Mon, Mar 15, 2021 at 06:28:42PM +0100, Vlastimil Babka wrote:
>> On 3/15/21 6:16 PM, David Rientjes wrote:
>> > On Mon, 15 Mar 2021, Vlastimil Babka wrote:
>> > 
>> >> Commit ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
>> >> introduced a static key to optimize the case where no debugging is enabled for
>> >> any cache. The static key is enabled when slub_debug boot parameter is passed,
>> >> or CONFIG_SLUB_DEBUG_ON enabled.
>> >> 
>> >> However, some caches might be created with one or more debugging flags
>> >> explicitly passed to kmem_cache_create(), and the commit missed this. Thus the
>> >> debugging functionality would not be actually performed for these caches unless
>> >> the static key gets enabled by boot param or config.
>> >> 
>> >> This patch fixes it by checking for debugging flags passed to
>> >> kmem_cache_create() and enabling the static key accordingly.
>> >> 
>> >> Note such explicit debugging flags should not be used outside of debugging and
>> >> testing as they will now enable the static key globally. btrfs_init_cachep()
>> >> creates a cache with SLAB_RED_ZONE but that's a mistake that's being corrected
>> >> [1]. rcu_torture_stats() creates a cache with SLAB_STORE_USER, but that is a
>> >> testing module so it's OK and will start working as intended after this patch.
>> >> 
>> >> Also note that in case of backports to kernels before v5.12 that don't have
>> >> 59450bbc12be ("mm, slab, slub: stop taking cpu hotplug lock"),
>> >> static_branch_enable_cpuslocked() should be used.
>> >> 
>> > 
>> > Since this affects 5.9+, is the plan to propose backports to stable with 
>> > static_branch_enable_cpuslocked() once this is merged?  (I notice the 
>> > absence of the stable tag here, which I believe is intended.)
>> 
>> I was thinking about it, and since the rcutorture user is only in -next (AFAICS)
>> and btrfs user was unintended, it didn't seem to meet stable criteria to me. But
>> I won't mind if it's backported.
> 
> I had better ask...  Should rcutorture be doing something different?
> 
> 							Thanx, Paul

No, I think it's fine if a testing module such as rcutorture flips the static
key for the rest of the kernel's uptime. I only CC'd you as FYI in case you were
wondering why you can't see any alloc/free stacks in its output :)
