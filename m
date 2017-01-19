Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33014 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754408AbdASTTL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 14:19:11 -0500
Received: by mail-yw0-f196.google.com with SMTP id u68so5736245ywg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 11:18:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$356c$39bebeff$a6d8a6ee$dcbb0048@cox.net>
References: <cd74d77f-bba5-6301-f0dc-6b2323adebdb@hawaii.edu>
 <CAJCQCtRYz9Gcqfc44Je9oqjXx-H-N8nbXp0TuzZcE6SN+ZCm8A@mail.gmail.com> <pan$356c$39bebeff$a6d8a6ee$dcbb0048@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 19 Jan 2017 12:18:04 -0700
Message-ID: <CAJCQCtQvaG0OmprEBR-W1cVFh-4t2sEXmr=M0kgD4RME7_H9uA@mail.gmail.com>
Subject: Re: Raid 1 recovery
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 19, 2017 at 12:15 AM, Duncan <1i5t5.duncan@cox.net> wrote:
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

If the udev rule isn't there, there's a chance that there's a mount
failure with any multiple device setup if one member device is late to
the party. If the udev rule is removed and if rootflags=degraded, now
whenever there's a late device, there's always a degraded boot and the
drive late to the party is out of sync. And we have no fast resync
like mdadm with write intent bitmaps, so it requires a complete volume
scrub (initiated manually) to avoid corruption, as soon as the volume
is made whole.

Now maybe the udev rule could be made smarter, I don't really know. If
it's multiple device you'd want a rule that just waits for say, 30
seconds or a minute or something sane, whatever that'd be. That way
normal operation just delays things a bit to make sure all member
drives are available at the same time, so that the mount command
(without degraded option) works. And the only failure case is when
there is in fact a bad drive. Someone willing to take the risk could
use such a udev rule along with rootflags=degraded, but this is asking
for trouble.

What's really needed is a daemon or other service that manages the
pool status. And that includes dealing with degradedness and resyncs
automatically.



-- 
Chris Murphy
