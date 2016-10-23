Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42062 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756635AbcJWVco (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Oct 2016 17:32:44 -0400
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
Date: Sun, 23 Oct 2016 17:32:21 -0400
MIME-Version: 1.0
In-Reply-To: <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/22/2016 11:20 AM, Dave Jones wrote:
> On Fri, Oct 21, 2016 at 04:02:45PM -0400, Dave Jones wrote:
>
>  >  > It could be worth trying this, too:
>  >  >
>  >  > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=174531fef4e8
>  >  >
>  >  > It occurred to me that the current code is a little bit fragile.
>  >
>  > It's been nearly 24hrs with the above changes, and it's been pretty much
>  > silent the whole time.
>  >
>  > The only thing of note over that time period has been a btrfs lockdep
>  > warning that's been around for a while, and occasional btrfs checksum
>  > failures, which I've been seeing for a while, but seem to have gotten
>  > worse since 4.8.
>  >
>  > I'm pretty confident in the disk being ok in this machine, so I think
>  > the checksum warnings are bogus.  Chris suggested they may be the result
>  > of memory corruption, but there's little else going on.
>
> The only interesting thing last nights run was this..
>
> BUG: Bad page state in process kworker/u8:1  pfn:4e2b70
> page:ffffea00138adc00 count:0 mapcount:0 mapping:ffff88046e9fc2e0 index:0xdf0
> flags: 0x400000000000000c(referenced|uptodate)
> page dumped because: non-NULL mapping
> CPU: 3 PID: 24234 Comm: kworker/u8:1 Not tainted 4.9.0-rc1-think+ #11
> Workqueue: writeback wb_workfn (flush-btrfs-2)

Well crud, we're back to wondering if this is Btrfs or the stack 
corruption.  Since the pagevecs are on the stack and this is a new 
crash, my guess is you'll be able to trigger it on xfs/ext4 too.  But we 
should make sure.

-chris
