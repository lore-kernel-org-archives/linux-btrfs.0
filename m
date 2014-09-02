Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:38697 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaIBUXx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 16:23:53 -0400
Received: by mail-lb0-f182.google.com with SMTP id u10so8406049lbd.27
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 13:23:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54062424.9040508@fb.com>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
	<pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
	<CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com>
	<pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
	<CANg_oxxiAJbchugA2puD7PE3qgd_iQ+Lwpzs416YPBUBCKVOag@mail.gmail.com>
	<54062424.9040508@fb.com>
Date: Tue, 2 Sep 2014 22:23:51 +0200
Message-ID: <CANg_oxy5p8mxeHtjGjVRvvntE9JY_yXxRFRDjbSny=XGa1ZGfg@mail.gmail.com>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: john terragon <jterragon@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know what to tell you about the ENOSPC code being heavily
involved. At this point I'm using this simple test to see if things
improve:

-freshly created btrfs on dmcrypt,
-rsync some stuff (since the fs is empty I could just use cp but I
keep the test the same as it was when I had the problem for the first
time)
-note: the rsynced stuff is about the size of the volume but with
compression I always end up with 1/2 to 3/4 free space

I'm not sure how do I even get close to involving the ENOSPC code but
probably I'm not fully aware of the inner workings of btrfs.

> Can you try flipping off autodefrag?

As soon as the damn unkillable rsync decides to obey the kill -9...

Thanks

John

On Tue, Sep 2, 2014 at 10:10 PM, Chris Mason <clm@fb.com> wrote:
>> On 09/02/2014 03:56 PM, john terragon wrote:
>> Nice...now I get the hung task even with 3.14.17.... And I tried with
>> 4K for node and leaf size...same result. And to top it all off, today
>> I've been bitten by the bug also on my main root fs (which is on two
>> fast ssd), although with 3.16.1.
>>
>> Is it at least safe for the data? I mean, as long as the hung process
>> terminates and no other error shows up, can I at least be sure that
>> the data written is correct?
>
> Your traces are a little different.  The ENOSPC code is throttling
> things to make sure you have enough room for the writes you're doing.
> The code we have in 3.17-rc3 (or my for-linus branch) are the best
> choices right now.  You can pull that down to 3.16 if you want all the
> fixes on a more stable kernel.
>
> Nailing down the ENOSPC code is going to be a little different, I think
> autodefrag probably isn't interacting well with being short on space and
> encryption.  This is leading to much more IO than we'd normally do, and
> dm-crypt makes it fairly intensive.
>
> Can you try flipping off autodefrag?
>
> -chris
