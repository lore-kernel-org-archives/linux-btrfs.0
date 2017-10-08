Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:48247 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdJHVDq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 17:03:46 -0400
Received: by mail-oi0-f43.google.com with SMTP id m198so24339988oig.5
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Oct 2017 14:03:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH-droxSCv9CfPE2gDAmmDV33ucjh7nABNvmv=fsCzdewcm7rQ@mail.gmail.com>
References: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
 <20171007000837.GD19068@lim.localdomain> <CAH-droxSCv9CfPE2gDAmmDV33ucjh7nABNvmv=fsCzdewcm7rQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 8 Oct 2017 22:03:45 +0100
Message-ID: <CAJCQCtRYkEQzCVqTbeE5cxOffFmqB5TFoU5wXaneZ+34NefaFA@mail.gmail.com>
Subject: Re: "BTRFS error (device vda1): couldn't get super buffer head for
 bytenr x"
To: Nick Gilmour <nickeforos@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 8, 2017 at 4:39 PM, Nick Gilmour <nickeforos@gmail.com> wrote:
> Thanks for the reply!
>
> For conversion I used this command:
> $ vboxmanage internalcommands converttoraw mydisk.vdi mydisk.img
>
> and for resizing this one:
> $ qemu-img resize mydisk.img 150G
>
> Is there something I can do to fix this or another way to do the
> resizing without getting an error?

I don't see a 'btrfs filesystem resize' command in your sequence. Did
you actually resize the file system before you resized the underlying
(virtual) block device?



>>> btrfs fi show
>>> Label: none uuid: x
>>>            Total devices 1 FS bytes used 473.68GiB
>>>             devid 1 size 492.00 GiB used 492.00GiB path /dev/sda1

Is this before or after the resize?




-- 
Chris Murphy
