Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:56655 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbdJIA1g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 20:27:36 -0400
Received: by mail-qt0-f195.google.com with SMTP id 34so23268125qtb.13
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Oct 2017 17:27:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRYkEQzCVqTbeE5cxOffFmqB5TFoU5wXaneZ+34NefaFA@mail.gmail.com>
References: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
 <20171007000837.GD19068@lim.localdomain> <CAH-droxSCv9CfPE2gDAmmDV33ucjh7nABNvmv=fsCzdewcm7rQ@mail.gmail.com>
 <CAJCQCtRYkEQzCVqTbeE5cxOffFmqB5TFoU5wXaneZ+34NefaFA@mail.gmail.com>
From: Nick Gilmour <nickeforos@gmail.com>
Date: Mon, 9 Oct 2017 02:26:55 +0200
Message-ID: <CAH-drozwUJBJq_TJxTDSCttEB6Ff-GiuroQBJ-qyPOe05ott8g@mail.gmail.com>
Subject: Re: "BTRFS error (device vda1): couldn't get super buffer head for
 bytenr x"
To: Chris Murphy <lists@colorremedies.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I don't see a 'btrfs filesystem resize' command in your sequence. Did
> you actually resize the file system before you resized the underlying
> (virtual) block device?

OK. I guess, this is it. I didn't do any 'btrfs filesystem resize' .
The guides I was following didn't mention something like that. I was
assuming that if it works for other FS like this it should also work
for BTRFS. So I have to run this one:

# btrfs filesystem resize -350g /home ?

Should it be before or after I shrink the .img?

> Is this before or after the resize?

 It's after the supposed resize. I shoud have seen that BTRFS didn't
notice the change...

On Sun, Oct 8, 2017 at 11:03 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Oct 8, 2017 at 4:39 PM, Nick Gilmour <nickeforos@gmail.com> wrote:
>> Thanks for the reply!
>>
>> For conversion I used this command:
>> $ vboxmanage internalcommands converttoraw mydisk.vdi mydisk.img
>>
>> and for resizing this one:
>> $ qemu-img resize mydisk.img 150G
>>
>> Is there something I can do to fix this or another way to do the
>> resizing without getting an error?
>
> I don't see a 'btrfs filesystem resize' command in your sequence. Did
> you actually resize the file system before you resized the underlying
> (virtual) block device?
>
>
>
>>>> btrfs fi show
>>>> Label: none uuid: x
>>>>            Total devices 1 FS bytes used 473.68GiB
>>>>             devid 1 size 492.00 GiB used 492.00GiB path /dev/sda1
>
> Is this before or after the resize?
>
>
>
>
> --
> Chris Murphy
