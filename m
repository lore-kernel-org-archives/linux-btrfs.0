Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38779 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdILTL5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 15:11:57 -0400
Received: by mail-it0-f44.google.com with SMTP id c195so1013918itb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 12:11:57 -0700 (PDT)
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Marat Khalili <mkh@rqc.ru>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
 <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
 <20170912184359.hovirdaj55isvwwg@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7019ace9-723e-0220-6136-473ac3574b55@gmail.com>
Date: Tue, 12 Sep 2017 15:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <20170912184359.hovirdaj55isvwwg@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-12 14:43, Adam Borowski wrote:
> On Tue, Sep 12, 2017 at 01:36:48PM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-09-12 13:21, Adam Borowski wrote:
>>> There's fallocate -d, but that for some reason touches mtime which makes
>>> rsync go again.  This can be handled manually but is still not nice.
> 
>> It touches mtime because it updates the block allocations, which in turn
>> touch ctime, which on most (possibly all, not sure though) POSIX systems
>> implies an mtime update.  It's essentially the same as truncate updating the
>> mtime when you extend the file, the only difference is that the
>> FALLOCATE_PUNCH_HOLES ioctl doesn't change the file size.
> 
> Yeah, the underlying ioctl does modify the file, it's merely fallocate -d
> calling it on regions that are already zero.  The ioctl doesn't know that,
> so fallocate would have to restore the mtime by itself.
> 
> There's also another problem: such a check + ioctl are racey.  Unlike defrag
> or FILE_EXTENT_SAME, you can't thus use it on a file that's in use (or could
> suddenly become in use).  Fixing this would need kernel support, either as
> FILE_EXTENT_SAME with /dev/zero or as a new mode of fallocate.
A new fallocate mode would be more likely.  Adding special code to the 
EXTENT_SAME ioctl and then requiring implementation on filesystems that 
don't otherwise support it is not likely to get anywhere.  A new 
fallocate mode though would be easy, especially considering that a naive 
implementation is easy (block further requests to that range, complete 
all outstanding ones, check the range, punch the hole if possible, and 
then reopen requests for the range).

That said, I'm not 100% certain if it's necessary.  Intentionally 
calling fallocate on a file in use is not something most people are 
going to do normally anyway, since there is already a TOCTOU race in the 
fallocate -d implementation as things are right now.
> 
> For now, though, I wonder -- should we send fine folks at util-linux a patch
> to make fallocate -d restore mtime, either always or on an option?
It would need to be an option, because it also suffers from a TOCTOU 
race (other things might have changed the mtime while you were punching 
holes), and it breaks from existing behavior.  I think such an option 
would be useful, but not universally (for example, I don't care if the 
mtime on my VM images changes, as it typically matches the current date 
and time since the VM's are running constantly other than when doing 
maintenance like punching holes in the images).

You're the one with particular interest though, so I guess it's 
ultimately up to you how you choose to implement things in the patch ;)
