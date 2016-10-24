Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40466 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751821AbcJXWC6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 18:02:58 -0400
Subject: Re: bio linked list corruption.
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
References: <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <CALCETrXoGd3gq=g61q07JDNTSaY7TjDoPQd3F8UgiwDfyJVLug@mail.gmail.com>
 <CA+55aFycKG_7qpSs_pH7ibnOYL9vM85UMGhUFEGC-qpB4qkb5A@mail.gmail.com>
 <CA+55aFyqUvb1BEraMp2LGK7Hm1xwzQzwsWb+KykpZiYSQ5cUEA@mail.gmail.com>
 <CA+55aFwE3x_w9+8SkHGBAGR5Du7P18+e55GWzcKOrORh87c7Qg@mail.gmail.com>
CC: Dave Jones <davej@codemonkey.org.uk>, Andy Lutomirski <luto@kernel.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <b6b07630-26bf-6886-4257-68d3a4fa9b8c@fb.com>
Date: Mon, 24 Oct 2016 18:02:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwE3x_w9+8SkHGBAGR5Du7P18+e55GWzcKOrORh87c7Qg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/24/2016 05:50 PM, Linus Torvalds wrote:
> On Mon, Oct 24, 2016 at 2:17 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> The vmalloc/vfree code itself is a bit scary. In particular, we have a
>> rather insane model of TLB flushing. We leave the virtual area on a
>> lazy purge-list, and we delay flushing the TLB and actually freeing
>> the virtual memory for it so that we can batch things up.
>
> Never mind. If DaveJ is running with DEBUG_PAGEALLOC, then the code in
> vmap_debug_free_range() should have forced a synchronous TLB flush fro
> vmalloc ranges too, so that doesn't explain it either.
>

My big fear here is that we're just triggering an old stack corruption 
more reliably.  I wonder if we can make it happen much faster by 
restricting the stacks to a static list and cycling through them in lifo 
fashion?

-chris

