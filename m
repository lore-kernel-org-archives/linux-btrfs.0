Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754619AbcJUUqh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 16:46:37 -0400
Subject: Re: bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <e094eb48-3007-f28a-12f6-6a162a43ad32@fb.com>
 <20161021202325.q6uh7k2pgnv276rg@codemonkey.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <0cbc7ee4-9268-9765-dde7-1e28c4cdf8f0@fb.com>
Date: Fri, 21 Oct 2016 16:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <20161021202325.q6uh7k2pgnv276rg@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/21/2016 04:23 PM, Dave Jones wrote:
> On Fri, Oct 21, 2016 at 04:17:48PM -0400, Chris Mason wrote:
>
>  > > BTRFS warning (device sda3): csum failed ino 130654 off 0 csum 2566472073 expected csum 3008371513
>  > > BTRFS warning (device sda3): csum failed ino 131057 off 4096 csum 3563910319 expected csum 738595262
>  > > BTRFS warning (device sda3): csum failed ino 131176 off 4096 csum 1344477721 expected csum 441864825
>  > > BTRFS warning (device sda3): csum failed ino 131241 off 245760 csum 3576232181 expected csum 2566472073
>  > > BTRFS warning (device sda3): csum failed ino 131429 off 0 csum 1494450239 expected csum 2646577722
>  > > BTRFS warning (device sda3): csum failed ino 131471 off 0 csum 3949539320 expected csum 3828807800
>  > > BTRFS warning (device sda3): csum failed ino 131471 off 4096 csum 3475108475 expected csum 2566472073
>  > > BTRFS warning (device sda3): csum failed ino 131471 off 958464 csum 142982740 expected csum 2566472073
>  > > BTRFS warning (device sda3): csum failed ino 131471 off 0 csum 3949539320 expected csum 3828807800
>  > > BTRFS warning (device sda3): csum failed ino 131532 off 270336 csum 3138898528 expected csum 2566472073
>  > > BTRFS warning (device sda3): csum failed ino 131532 off 1249280 csum 2169165042 expected csum 2566472073
>  > > BTRFS warning (device sda3): csum failed ino 131649 off 16384 csum 2914965650 expected csum 1425742005
>  > >
>  > >
>  > > A curious thing: the expected csum 2566472073 turns up a number of times for different inodes, and gets
>  > > differing actual csums each time.  I suppose this could be something like a block of all zeros in multiple files,
>  > > but it struck me as surprising.
>  > >
>  > > btrfs people: is there an easy way to map those inodes to a filename ? I'm betting those are the
>  > > test files that trinity generates. If so, it might point to a race somewhere.
>  >
>  > btrfs inspect inode 130654 mntpoint
>
> Interesting, they all return
>
> ERROR: ino paths ioctl: No such file or directory
>
> So these files got deleted perhaps ?
>
Yeah, they must have.

-chris

