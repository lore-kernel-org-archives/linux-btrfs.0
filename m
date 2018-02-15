Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33144 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167118AbeBOTGu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:06:50 -0500
Date: Thu, 15 Feb 2018 20:06:47 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: "Ellis H. Wilson III" <ellisw@panasas.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Metadata / Data on Heterogeneous Media
Message-ID: <20180215190647.ato4mnvzzom36frc@angband.pl>
References: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 12:15:49PM -0500, Ellis H. Wilson III wrote:
> In discussing the performance of various metadata operations over the past
> few days I've had this idea in the back of my head, and wanted to see if
> anybody had already thought about it before (likely, I would guess).
>
> It appears based on this page:
> https://btrfs.wiki.kernel.org/index.php/Btrfs_design
> that data and metadata in BTRFS are fairly well isolated from one another,
> particularly in the case of large files.  This appears reinforced by a
> recent comment from Qu ("...btrfs strictly
> split metadata and data usage...").
> 
> Yet, while there are plenty of options to RAID0/1/10/etc across generally
> homogeneous media types, there doesn't appear to be any functionality (at
> least that I can find) to segment different BTRFS internals to different
> types of devices.  E.G., place metadata trees and extent block groups on
> SSD, and data trees and extent block groups on HDD(s).
> 
> Is this something that has already been considered (and if so, implemented,
> which would make me extremely happy)?  Is it feasible it is hasn't been
> approached yet?  I admit my internal knowledge of BTRFS is fleeting, though
> I'm trying to work on that daily at this time, so forgive me if this is
> unapproachable for obvious architectural reasons.

Considered: many times.  It's an obvious improvement, and one that shouldn't
even be that hard to implement.  What remains, it's SMoC then SMoR (Simple
Matter of Coding then Simple Matter of Review), but both of those are in
short supply.

After the maximum size of inline extents has been lowered, there's no real
point in putting different types of metadata or not-really-metadata on
different media: thus, existing split of data -vs- metadata block groups is
fine.

What you'd want is an ability to tell the block allocator that metadata
block groups should prefer device[s] A, while data ones, device[s] B.

Right now, the allocator's algorithm is: any new allocations are placed on
device that has the most available space, for 2nd/etc RAID chunk obviously
excluding the device which 1st chunk has been already placed on.  This is
optimal wrt not wasting space, but doesn't always provide best performance,
especially when devices' speed varies.  There are also other downsides, like
usual RAID10 having 2/3 chance for tolerating two missing devices, while
btrfs RAID10 almost guarantees massive data loss with two missing devices.

Thus, allowing to specify an allocation policy that alters this algorithm
would be the way to go.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ The bill with 3 years prison for mentioning Polish concentration
⣾⠁⢰⠒⠀⣿⡁ camps is back.  What about KL Warschau (operating until 1956)?
⢿⡄⠘⠷⠚⠋⠀ Zgoda?  Łambinowice?  Most ex-German KLs?  If those were "soviet
⠈⠳⣄⠀⠀⠀⠀ puppets", Bereza Kartuska?  Sikorski's camps in UK (thanks Brits!)?
