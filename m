Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35451 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdESTUy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 15:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <20170519181009.GA10137@lim.localdomain>
References: <20170518133351.1867577-1-arnd@arndb.de> <20170519181009.GA10137@lim.localdomain>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 19 May 2017 21:20:53 +0200
Message-ID: <CAK8P3a27VTFWp=kGusXDcwy7tU2FHJc63K65p7OR1RExdpVHCA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: work around maybe-uninitialized warning
To: bo.li.liu@oracle.com
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 8:10 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, May 18, 2017 at 03:33:29PM +0200, Arnd Bergmann wrote:
>> A rewrite of btrfs_submit_direct_hook appears to have introduced a warning:
>>
>> fs/btrfs/inode.c: In function 'btrfs_submit_direct_hook':
>> fs/btrfs/inode.c:8467:14: error: 'bio' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>
>> Where the 'bio' variable was previously initialized unconditionally, it
>> is now set in the "while (submit_len > 0)" loop that would never execute
>> if submit_len is zero.
>>
>> Assuming this cannot happen in practice, we can avoid the warning
>> by simply replacing the while{} loop with a do{}while() loop so
>> the compiler knows that it will always be entered at least once.
>>
>
> Thanks for the fix.  I think it's a false positve one and I've updated it in v2
> with a 'struct bio *bio = NULL' to make compiler happy, could you please help
> reveiw it?

Right, it is a false positive and adding the =NULL initialization shuts up the
warning. The reason my patch used a different approach is to make the
code more robust, see https://rusty.ozlabs.org/?p=232

Generally speaking initializing a local variable to an illegal value, and later
using the variable without a check for that original value is error-prone.
Even though the code is correct at the moment, someone else might
modify it later. My first (broken) solution avoided this by checking for
the condition that led to the warning, my newer solution is nicer as it
makes it much clearer to the reader what is going on, compared to
the NULL initialization that does not help readability but makes
it slightly harder to understand why you wrote the code specifically that
way.

       Arnd
