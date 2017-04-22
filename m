Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45809 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424296AbdDVSB0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 14:01:26 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [4.9] btrfs check --repair looping over file extent discount errors
Date: Sat, 22 Apr 2017 20:01:21 +0200
Message-ID: <9704759.LWOGv3LNzJ@merkaba>
In-Reply-To: <CAJCQCtSxi8kHhcdfLz52vH5-_Fvr55Jrrf4djpZpUVh+Ng0Z6w@mail.gmail.com>
References: <1603810.ePCDQapENk@merkaba> <CAJCQCtSxi8kHhcdfLz52vH5-_Fvr55Jrrf4djpZpUVh+Ng0Z6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris.

Chris Murphy - 22.04.17, 09:31:
> Is the file system created with no-holes?

I have how to find out about it and while doing accidentally set that feature 
on another filesystem (btrfstune only seems to be able to enable the feature, 
not show the current state of it).

But as there is no notice of the feature being set as standard in manpage of 
mkfs.btrfs as of BTRFS tools 4.9.1 and as I didn´t set it myself, I best bet 
is that the feature is not enable on the filesystem.

Now I wonder… how to disable the feature on that other filesystem again.

Thanks,
