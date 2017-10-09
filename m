Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:49853 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbdJIJ2H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Oct 2017 05:28:07 -0400
Received: by mail-oi0-f43.google.com with SMTP id w197so34126336oif.6
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Oct 2017 02:28:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH-drozNA1N6xO2dAknLD-JQu75BAEi+GpiEibA-R-Zk1U7xmA@mail.gmail.com>
References: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
 <20171007000837.GD19068@lim.localdomain> <CAH-droxSCv9CfPE2gDAmmDV33ucjh7nABNvmv=fsCzdewcm7rQ@mail.gmail.com>
 <CAJCQCtRYkEQzCVqTbeE5cxOffFmqB5TFoU5wXaneZ+34NefaFA@mail.gmail.com> <CAH-drozNA1N6xO2dAknLD-JQu75BAEi+GpiEibA-R-Zk1U7xmA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 9 Oct 2017 10:28:06 +0100
Message-ID: <CAJCQCtSchpVsL2Gr3dm+4MQuHDBU96UG9Gf_imBWqXRMD01+yw@mail.gmail.com>
Subject: Re: "BTRFS error (device vda1): couldn't get super buffer head for
 bytenr x"
To: Nick Gilmour <nickeforos@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Liu Bo <bo.li.liu@oracle.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 9, 2017 at 1:22 AM, Nick Gilmour <nickeforos@gmail.com> wrote:
>> I don't see a 'btrfs filesystem resize' command in your sequence. Did
>> you actually resize the file system before you resized the underlying
>> (virtual) block device?
>
>
> OK. I guess, this is it. I didn't do any 'btrfs filesystem resize' . The
> guides I was following didn't mention something like that. I was assuming
> that if it works for other FS like this it should also work for BTRFS.

Literally all other file systems require the fs be resized first when
shrinking, before the underlying partition or virtual block device is
reduced. There is nothing unique about Btrfs in this respect.

Some tools will use fsadm in the sequence to make sure the file system
is properly resized. So the question is whether any of the resize
tools you did use, expect to use fsadm. And if they do or did, whether
and why there wasn't an error if fsadm doesn't support Btrfs before
the block device was resized anyway. I don't know offhand if Btrfs is
supported by fsadmn, the man page does not list it as one of the
supported file systems.



> # btrfs filesystem resize -350g /home ?
>
> Should it be before or after I shrink the .img?

When shrinking, the fs resize must happen first. Then the block device
can be reduced to match.

When growing, the block device is extended, then the fs is resized.




-- 
Chris Murphy
