Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34653 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933101AbcJ0QhL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 12:37:11 -0400
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
References: <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <20161027063356.GA547@infradead.org>
 <CA+55aFy1OGO27GVhM9JmCpUp0W8-o1V3HmxP2_bU_tPd5xqGsg@mail.gmail.com>
CC: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <59242003-714a-028d-95f1-d313658f9a6f@fb.com>
Date: Thu, 27 Oct 2016 10:36:16 -0600
MIME-Version: 1.0
In-Reply-To: <CA+55aFy1OGO27GVhM9JmCpUp0W8-o1V3HmxP2_bU_tPd5xqGsg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/27/2016 10:34 AM, Linus Torvalds wrote:
> On Wed, Oct 26, 2016 at 11:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
>>> Dave, can you hit the warnings with this? Totally untested...
>>
>> Can we just kill off the unhelpful blk_map_ctx structure, e.g.:
>
> Yeah, I found that hard to read too. The difference between
> blk_map_ctx and blk_mq_alloc_data is minimal, might as well just use
> the latter everywhere.
>
> But please separate that patch from the patch that fixes the ctx list
> corruption.

Agree

> And Jens - can I have at least the corruption fix asap? Due to KS
> travel, I'm going to do rc3 on Saturday, and I'd like to have the fix
> in at least a day before that..

Just committed half an hour ago with the acks etc, I'll send it to you
shortly.

-- 
Jens Axboe

