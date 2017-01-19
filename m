Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60042 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdASHQC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 02:16:02 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cU6wf-0006KN-Tq
        for linux-btrfs@vger.kernel.org; Thu, 19 Jan 2017 08:15:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid 1 recovery
Date: Thu, 19 Jan 2017 07:15:19 +0000 (UTC)
Message-ID: <pan$356c$39bebeff$a6d8a6ee$dcbb0048@cox.net>
References: <cd74d77f-bba5-6301-f0dc-6b2323adebdb@hawaii.edu>
        <CAJCQCtRYz9Gcqfc44Je9oqjXx-H-N8nbXp0TuzZcE6SN+ZCm8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 18 Jan 2017 14:30:28 -0700 as excerpted:

> On Wed, Jan 18, 2017 at 2:07 PM, Jon <jmoroney@hawaii.edu> wrote:
>> So, I had a raid 1 btrfs system setup on my laptop. Recently I upgraded
>> the drives and wanted to get my data back. I figured I could just plug
>> in one drive, but I found that the volume simply would not mount. I
>> tried the other drive alone and got the same thing. Plugging in both at
>> the same time and the volume mounted without issue.
> 
> Requires mount option degraded.
> 
> If this is a boot volume, this is difficult because the current udev
> rule prevents a mount attempt so long as all devices for a Btrfs volume
> aren't present.

OK, so I've known about this from the list for some time, but what is the 
status with regard to udev/systemd (has a bug/issue been filed, results, 
link?), and what are the alternatives, both for upstream, and for a dev, 
either trying to be proactive, or currently facing a refusal to boot due 
to the issue?

IOW, I run btrfs raid1 on /, setup before the udev rule I believe as it 
worked back then, and I've known about the issue but haven't followed it 
closely enough to know what I should do if faced with a dead device, or 
what the current status is on alternatives to fix the problem longer 
term, either locally (does simply disabling the rule work?) or upstream, 
and what the alternatives might be along with the reasons this is still 
shipping instead.  And I'm asking in ordered to try to remedy that. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

