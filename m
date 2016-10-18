Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50045 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757066AbcJRXqI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 19:46:08 -0400
Date: Tue, 18 Oct 2016 19:42:49 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <axboe@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161018234248.GB93792@clm-mbp.masoncoding.com>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
 <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2016 at 04:39:22PM -0700, Linus Torvalds wrote:
>On Tue, Oct 18, 2016 at 4:31 PM, Chris Mason <clm@fb.com> wrote:
>>
>> Jens, not sure if you saw the whole thread.  This has triggered bad page
>> state errors, and also corrupted a btrfs list.  It hurts me to say, but it
>> might not actually be your fault.
>
>Where is that thread, and what is the "this" that triggers problems?
>
>Looking at the "->mq_list" users, I'm not seeing any changes there in
>the last year or so. So I don't think it's the list itself.

Seems to be the whole thing:

http://www.gossamer-threads.com/lists/linux/kernel/2545792

My guess is xattr, but I don't have a good reason for that.

-chris
