Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:36411 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbdASKq6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 05:46:58 -0500
Received: by mail-qt0-f176.google.com with SMTP id k15so61524175qtg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 02:46:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$356c$39bebeff$a6d8a6ee$dcbb0048@cox.net>
References: <cd74d77f-bba5-6301-f0dc-6b2323adebdb@hawaii.edu>
 <CAJCQCtRYz9Gcqfc44Je9oqjXx-H-N8nbXp0TuzZcE6SN+ZCm8A@mail.gmail.com> <pan$356c$39bebeff$a6d8a6ee$dcbb0048@cox.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Thu, 19 Jan 2017 13:46:12 +0300
Message-ID: <CAA91j0UoEJTj0GD7Rna829b40ED0Tbm0c+4++aYHaLaNeMbF0A@mail.gmail.com>
Subject: Re: Raid 1 recovery
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 19, 2017 at 10:15 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Wed, 18 Jan 2017 14:30:28 -0700 as excerpted:
>
>> On Wed, Jan 18, 2017 at 2:07 PM, Jon <jmoroney@hawaii.edu> wrote:
>>> So, I had a raid 1 btrfs system setup on my laptop. Recently I upgraded
>>> the drives and wanted to get my data back. I figured I could just plug
>>> in one drive, but I found that the volume simply would not mount. I
>>> tried the other drive alone and got the same thing. Plugging in both at
>>> the same time and the volume mounted without issue.
>>
>> Requires mount option degraded.
>>
>> If this is a boot volume, this is difficult because the current udev
>> rule prevents a mount attempt so long as all devices for a Btrfs volume
>> aren't present.
>
> OK, so I've known about this from the list for some time, but what is the
> status with regard to udev/systemd (has a bug/issue been filed, results,
> link?), and what are the alternatives, both for upstream, and for a dev,
> either trying to be proactive, or currently facing a refusal to boot due
> to the issue?
>

The only possible solution is to introduce separate object that
represents btrsf "storage" (raid) that exports information whether it
can be mounted. Then it is possible to start timer and decide to mount
degraded after timer expires.

Compare with Linux MD that is assembled by udev as well and does exactly that.

Where this object is better implemented - I do not know. It can be
btrfs side (export pseudo device similar to /dev/mdX for Linux MD). It
can be user space - special service that waits for device assembly.

Abstracting it on btrfs level is more clean and does not depend on
specific user space (a.k.a. udev/systemd). OTOH zfs shares the same
problem at the end, so common solution to multi-device filesystem
handling would be good.

> IOW, I run btrfs raid1 on /, setup before the udev rule I believe as it
> worked back then, and I've known about the issue but haven't followed it
> closely enough to know what I should do if faced with a dead device, or
> what the current status is on alternatives to fix the problem longer
> term, either locally (does simply disabling the rule work?) or upstream,
> and what the alternatives might be along with the reasons this is still
> shipping instead.  And I'm asking in ordered to try to remedy that. =:^)
>
