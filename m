Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:55925 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932398AbdJZVsH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 17:48:07 -0400
Received: by mail-io0-f179.google.com with SMTP id p186so8557438ioe.12
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 14:48:07 -0700 (PDT)
MIME-Version: 1.0
From: Cheyenne Wills <cheyenne.wills@gmail.com>
Date: Thu, 26 Oct 2017 15:48:06 -0600
Message-ID: <CAHpsFVe407Q975sOerXcvJOJ=T-CHq1bFSpRAzQFS9wjUw7u8g@mail.gmail.com>
Subject: Re: Need some assistance/direction in determining a system hang
 during heavy IO (resolved)
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 26, 2017 at 11:41 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Thu, 26 Oct 2017 09:40:19 -0600
> Cheyenne Wills <cheyenne.wills@gmail.com> wrote:
>
>> Briefly when I upgraded a system from 4.0.5 kernel to 4.9.5 (and
>> later) I'm seeing a blocked task timeout with heavy IO against a
>> multi-lun btrfs filesystem.  I've tried a 4.12.12 kernel and am still
>> getting the hang.
>
> There is now 4.9.58 (fifty three versions later!) and 4.12 series is long
> abandoned and gone from the charts altogether. So just in case, did you check
> with the latest kernels?
>
> Also, keep in mind the 120 second warnings are just that, and not an error
> condition by themselves. You can disable them or increase the maximum timeout
> in sysctl settings. And it is not clear from your reports if you only get
> warnings and after the load subsides everything is back to normal, or the FS
> locks out "for good", i.e. with all access attempts hanging indefinitely and
> no way to unmount the FS or otherwise recover.
>
> --
> With respect,
> Roman

Just tried a 4.13 kernel and it appears to have fixed the problem (at
least the scrub hasn't locked up).

Because the system didn't lock up, I was able to obtain some
additional information and it appears that
the core problem was a shortage of xen grant table frames.  By
increasing the gnttab_max_frames value in
the xen host, I was not able to cause a system hang (even with some of
the prior kernels -- well at
least a 4.12.12 kernel).

I ended up closing the above mentioned issue.  I included in the issue
some of the information that
I found so that if other folks are having the same problem there is
some discussion on a possible
solution.

When the system wasn't hanging with the 4.13 kernel, I was getting an
error message about
the grant tables.  Doing some searches with that information, I was
able to find a discussion
on

"I/O to LUNs hang / stall under high load when using xen-blkfront"

Turns out that the number of grant tables has a relationship with the
number of devices
attached to a xen guest.


Thanks for the assistance :)

Cheyenne Wills
