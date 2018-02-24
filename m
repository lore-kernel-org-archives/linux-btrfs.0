Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbeBXK7j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Feb 2018 05:59:39 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2575DAB38
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 10:59:38 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Relax memory barrier in btrfs_tree_unlock
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1518611846-26918-1-git-send-email-nborisov@suse.com>
 <20180224001420.GU1469@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c5867a7f-bb9d-adfc-829c-2045f8880765@suse.com>
Date: Sat, 24 Feb 2018 12:59:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180224001420.GU1469@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.02.2018 02:14, David Sterba wrote:
> On Wed, Feb 14, 2018 at 02:37:26PM +0200, Nikolay Borisov wrote:
>> When performing an unlock on an extent buffer we'd like to order the
>> decrement of extent_buffer::blocking_writers with waking up any
>> waiters. In such situations it's sufficient to use smp_mb__after_atomic
>> rather than the heavy smp_mb. On architectures where atomic operations
>> are fully ordered (such as x86 or s390) unconditionally executing
>> a heavyweight smp_mb instruction causes a severe hit to performance
>> while bringin no improvements in terms of correctness.
> 
> Have you measured this severe performance hit? There is an impact, but I
> doubt you'll ever notice it in the profiles given where the
> btrfs_tree_unlock appears.

Admittedly I haven't :) But I'd say "every little bit helps"

> 
>> The better thing is to use the appropriate smp_mb__after_atomic routine
>> which will do the correct thing (invoke a full smp_mb or in the case
>> of ordered atomics insert a compiler barrier). Put another way,
>> an RMW atomic op + smp_load__after_atomic equals, in terms of
>> semantics, to a full smp_mb. This ensures that none of the problems
>> described in the accompanying comment of waitqueue_active occur.
>> No functional changes.
> 
> I tend to agree.
> 
