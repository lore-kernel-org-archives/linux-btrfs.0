Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:37207 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbdILRgv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 13:36:51 -0400
Received: by mail-io0-f176.google.com with SMTP id j141so51787316ioj.4
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 10:36:51 -0700 (PDT)
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Adam Borowski <kilobyte@angband.pl>, Marat Khalili <mkh@rqc.ru>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
Date: Tue, 12 Sep 2017 13:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <20170912172125.rb6gtqdxqneb36js@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-12 13:21, Adam Borowski wrote:
> On Tue, Sep 12, 2017 at 02:26:39PM +0300, Marat Khalili wrote:
>> On 12/09/17 14:12, Adam Borowski wrote:
>>> Why would you need support in the hypervisor if cp --reflink=always is
>>> enough?
>> +1 :)
>>
>> But I've already found one problem: I use rsync snapshots for backups, and
>> although rsync does have --sparse argument, apparently it conflicts with
>> --inplace. You cannot have all nice things :(
(Replying here to the above, as I can't seem to find the original in my 
e-mail client to reply to)

--inplace and --sparse are inherently at odds with each other.  The only 
way that they could work together is if rsync was taught about the 
FALLOCATE_PUNCH_HOLES ioctl, and that isn't likely to ever happen 
because it's Linux specific (at least, it's functionally Linux 
specific).  Without that ioctl, the only way to create a sparse file is 
to seek over areas that are supposed to be empty when writing the file 
out initially, but you can't do that with an existing file because you 
then have old data where you're supposed to have zeroes.
> 
> There's fallocate -d, but that for some reason touches mtime which makes
> rsync go again.  This can be handled manually but is still not nice.It touches mtime because it updates the block allocations, which in turn 
touch ctime, which on most (possibly all, not sure though) POSIX systems 
implies an mtime update.  It's essentially the same as truncate updating 
the mtime when you extend the file, the only difference is that the 
FALLOCATE_PUNCH_HOLES ioctl doesn't change the file size.
