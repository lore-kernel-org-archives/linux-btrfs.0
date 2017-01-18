Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:34614 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdARVcP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 16:32:15 -0500
Received: by mail-yb0-f177.google.com with SMTP id j82so8350742ybg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 13:30:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd74d77f-bba5-6301-f0dc-6b2323adebdb@hawaii.edu>
References: <cd74d77f-bba5-6301-f0dc-6b2323adebdb@hawaii.edu>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 18 Jan 2017 14:30:28 -0700
Message-ID: <CAJCQCtRYz9Gcqfc44Je9oqjXx-H-N8nbXp0TuzZcE6SN+ZCm8A@mail.gmail.com>
Subject: Re: Raid 1 recovery
To: Jon <jmoroney@hawaii.edu>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2017 at 2:07 PM, Jon <jmoroney@hawaii.edu> wrote:
> So, I had a raid 1 btrfs system setup on my laptop. Recently I upgraded
> the drives and wanted to get my data back. I figured I could just plug
> in one drive, but I found that the volume simply would not mount. I
> tried the other drive alone and got the same thing. Plugging in both at
> the same time and the volume mounted without issue.

Requires mount option degraded.

If this is a boot volume, this is difficult because the current udev
rule prevents a mount attempt so long as all devices for a Btrfs
volume aren't present.


>
> I used raid 1 because I figured that if one drive failed I could simply
> use the other. This recovery scenario makes me think this is incorrect.
> Am I misunderstanding btrfs raid? Is there a process to go through for
> mounting single member of a raid pool?

mount -o degraded


-- 
Chris Murphy
