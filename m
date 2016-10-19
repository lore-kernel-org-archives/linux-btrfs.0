Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935028AbcJSATf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 20:19:35 -0400
Date: Tue, 18 Oct 2016 20:19:01 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <axboe@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161019001900.GA95500@clm-mbp.thefacebook.com>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
 <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2016 at 05:10:56PM -0700, Linus Torvalds wrote:
>On Tue, Oct 18, 2016 at 4:42 PM, Chris Mason <clm@fb.com> wrote:
>>
>> Seems to be the whole thing:
>
>Ahh. On lkml, so I do have it in my mailbox, but Dave changed the
>subject line when he tested on ext4 rather than btrfs..
>
>Anyway, the corrupted address is somewhat interesting. As Dave Jones
>said, he saw
>
>  list_add corruption. prev->next should be next (ffffe8ffff806648),
>but was ffffc9000067fcd8. (prev=ffff880503878b80).
>  list_add corruption. prev->next should be next (ffffe8ffffc05648),
>but was ffffc9000028bcd8. (prev=ffff880503a145c0).
>
>and Dave Chinner reports
>
>  list_add corruption. prev->next should be next (ffffe8ffffc02808),
>but was ffffc90005f6bda8. (prev=ffff88013363bb80).
>
>and it's worth noting that the "but was" is a remarkably consistent
>vmalloc address (the ffffc9000.. pattern gives it away). In fact, it's
>identical across two boots for DaveJ in the low 14 bits, and fairly
>high up in those low 14 bots (0x3cd8).
>
>DaveC has a different address, but it's also in the vmalloc space, and
>also looks like it is fairly high up in 14 bits (0x3da8). So in both
>cases it's almost certainly a stack address with a fairly empty stack.
>The differences are presumably due to different kernel configurations
>and/or just different filesystems calling the same function that does
>the same bad thing but now at different depths in the stack.
>
>Adding Andy to the cc, because this *might* be triggered by the
>vmalloc stack code itself. Maybe the re-use of stacks showing some
>problem? Maybe Chris (who can't see the problem) doesn't have
>CONFIG_VMAP_STACK enabled?

CONFIG_VMAP_STACK=y, but maybe I just need to hammer on process creation 
more.  I'm testing in a hugely stripped down VM, so Dave might have more 
background stuff going on.

-chris
