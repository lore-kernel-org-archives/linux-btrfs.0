Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:55509 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbeESAMp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 20:12:45 -0400
Date: Sat, 19 May 2018 01:55:30 +0200
From: Tomasz Pala <gotar@polanet.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Niccol?? Belli <darkbasic@linuxsystems.it>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: Any chance to get snapshot-aware defragmentation?
Message-ID: <20180518235530.GA12463@polanet.pl>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 13:10:02 -0400, Austin S. Hemmelgarn wrote:

> Personally though, I think the biggest issue with what was done was not 
> the memory consumption, but the fact that there was no switch to turn it 
> on or off.  Making defrag unconditionally snapshot aware removes one of 
> the easiest ways to forcibly unshare data without otherwise altering the 

The "defrag only not-snapshotted data" mode would be enough for many
use cases and wouldn't require more RAM. One could run this before
taking a snapshot and merge _at least_ the new data.

And even with current approach it should be possible to interlace
defragmentation with some kind of naive-deduplication; "naive" in the
approach of comparing blocks only within the same in-subvolume paths.

-- 
Tomasz Pala <gotar@pld-linux.org>
