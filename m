Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34577 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbcIOPiI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 11:38:08 -0400
Received: by mail-oi0-f47.google.com with SMTP id m11so75058451oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 08:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Sep 2016 09:38:04 -0600
Message-ID: <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Alexandre Poux <pums974@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 1:44 AM, Alexandre Poux <pums974@gmail.com> wrote:
> I had a btrfs partition on a 6 disk array without raid (metadata in
> raid10, but data in single), and one of the disks just died.
>
> So I lost some of my data, ok, I knew that.
>
> But two question :
>
>   *
>
>     Is it possible to know (using metadata I suppose) what data I have
>     lost ?

The safest option is to remount read only and do a read only scrub.
That will spit out messages for corrupt (missing) metadata and data,
to the kernel message buffer.  The  missing data will appear as
corrupt files that can't be fixed with full file paths. There will
likely be so many that dmesg will be useless so you'll need to use
journalctl -fk to follow the scrub; or journalctl -bk after the fact
or even -b-1 -k or -b-2 -k, etc.; or /var/log/messages as it's
probably going to exceed the kernel message buffer, so dmesg won't
help.




>     Is it possible to do some king of a "btrfs delete missing" on this
>     kind of setup, in order to recover access in rw to my other data, or
>     I must copy all my data on a new partition

That *should* work :) Except that your file system with 6 drives is
too full to be shrunk to 5 drives. Btrfs will either refuse, or get
confused, about how to shrink a nearly full 6 drive volume into 5.

So you'll have to do one of three things:

1. Add a 2+TB drive, then remove the missing one; OR
2. btrfs replace is faster and is raid10 reliable; OR
3. Read only scrub to get a file listing of bad files, then remount
read-write degraded and delete them all. Now you maybe can do a device
delete missing. But it's still a tight fit, it basically has to
balance things out to get it to fit on an odd number of drives, it may
actually not work even though there seems to be enough total space,
there has to be enough space on FOUR drives.


I'd go with option 2.  And that should still spit out the paths to bad
files. If the replace works, I'm pretty sure you still need to delete
all of the files that are missing in order to get rid of the
corruption warnings on any subsequent scrub or balance.



>
> btrfs --version :
> btrfs-progs v4.7.1

You should upgrade to 4.7.2 or downgrade to 4.6.1 before doing btrfs
check. Not urgent so long as you don't actually do a repair with this
version.



-- 
Chris Murphy
