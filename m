Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35667 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdAYXHP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 18:07:15 -0500
Received: by mail-yb0-f195.google.com with SMTP id j82so11410617ybg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 15:07:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170125225814.GA15621@vader>
References: <CAJCQCtQvt=xYtAGwPXk1Vhb7pmVNCbpFOg+W3Eh=-L9LSJkbaw@mail.gmail.com>
 <20170124201038.GB2853@vader> <CAJCQCtQm4RoN6zGEWDFTn9CigTaMM8Mxepc=UJhNhWCavp9U-A@mail.gmail.com>
 <20170124202723.GD2853@vader> <CAJCQCtQ-h++dwSRGtNp6RZXJjo0T63ouYwwM8PnasqGAyJCB=A@mail.gmail.com>
 <CAJCQCtQbHNyiK0L8MGk+2UO6ajGPBvowg6bg2EZPXpE3XySvWA@mail.gmail.com>
 <20170124225052.GA10425@vader> <CAJCQCtQ4tmCB4OBw1Jx43yunxMChRwKmcUVb1xSLr0KHwKSe-A@mail.gmail.com>
 <20170125044253.GA18885@vader> <CAJCQCtQiVAYDZM9WeucFgJANbQhb_G5fTE-2Jpo3fc3Ch_RPhQ@mail.gmail.com>
 <20170125225814.GA15621@vader>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 25 Jan 2017 16:07:09 -0700
Message-ID: <CAJCQCtQi5DQ=N0AukLMey5L4-v0mSXtgft9g0bUH1Hap+8ZjcA@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2017 at 3:58 PM, Omar Sandoval <osandov@osandov.com> wrote:
> On Wed, Jan 25, 2017 at 03:55:33PM -0700, Chris Murphy wrote:
>> On Tue, Jan 24, 2017 at 9:42 PM, Omar Sandoval <osandov@osandov.com> wrote:
>> > On Tue, Jan 24, 2017 at 07:53:06PM -0700, Chris Murphy wrote:
>> >> On Tue, Jan 24, 2017 at 3:50 PM, Omar Sandoval <osandov@osandov.com> wrote:
>> >>
>> >> > Got this to repro after installing systemd-container. It's happening on
>> >> > lsetxattr() to set the SELinux context on /var/lib/machines, which is a
>> >> > subvolume. Looking into it now. Thanks for all of the help, Chris.
>> >>
>> >> Aha! So the snapshot part was a goose chase, it has nothing to do with
>> >> that, really. Because I'm taking a snapshot of root, the nested
>> >> /var/lib/machines subvolume is not in that snapshot, so now it has to
>> >> be created by systemd at next boot and the proper selinux label set on
>> >> it.
>> >>
>> >> It means there's something different about subvolumes and directories
>> >> when it comes to xattrs, and the xattr patch I found in bisect is
>> >> exposing the difference, hence things getting tripped up.
>> >
>> > The snapshots were actually the key -- the error was because setxattr()
>> > was being allowed on the read-only directory created in the place of the
>> > /var/lib/machines subvolume. Not sure if you saw the patch I sent up,
>> > but this should fix it: https://patchwork.kernel.org/patch/9536307/
>>
>> Got it.
>>
>> I couldn't get it to apply to 4.9, but it goes on 4.10-rc5 and the
>> problem is fixed.
>
> Sweet, can I add your tested-by?

Yep!

-- 
Chris Murphy
