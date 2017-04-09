Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49110 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbdDIUsX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 16:48:23 -0400
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <22761.23640.216570.125948@tree.ty.sabi.co.uk>
 <e3e2c13c-8f5d-2848-a3f6-759259d84d9d@mendix.com>
 <20170409051424.28a086cb@jupiter.sol.kaishome.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <3aee0cac-ec4d-52f1-f872-8bc9e3874670@mendix.com>
Date: Sun, 9 Apr 2017 22:48:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170409051424.28a086cb@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2017 05:14 AM, Kai Krakow wrote:
> Am Sun, 9 Apr 2017 02:21:19 +0200
> schrieb Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
> 
>> [...]
>> The fundamental functionality of doing the cow snapshots, moo, and the
>> related subvolume removal on filesystem trees is so awesome. I have no
>> idea how we would have been able to continue this type of backup
>> system when btrfs was not available. Hardlinks and rm -rf was a total
>> dead end road.
> 
> I'm absolutely no expert with arrays of sizes that you use but I also
> stopped using the hardlink-and-remove approach: It was slow to manage
> (rsync works slow for it, rm works slow for it) and it was error-probe
> (due to the nature of hardlinks). I used btrfs with snapshots and rsync
> for a while in my personal testbed, and experienced great slowness over
> time: rsync started to become slower and slower, full backup took 4
> hours with huge %IO usage, maintaining the backup history was also slow
> (removing backups took a while), rebalancing was needed due to huge
> wasted space.

Did you debug why it was slow?

> I used rsync with --inplace and --no-whole-file to waste
> as few space as possible.

Most of the files on the remotes I backup do not change. There can be
new extra files, or files can be removed, but they don't change in place.

Files that change much, together with --inplace cause extra reflinking
of data, which at first seems to save space, but also makes backref
walking slower and causes more fragmentation and more places in the
trees that needs to change when doing balance and subvolume delete. So
that might have been one of the reasons for the increasing slowness.

And, of course always make sure *everything* runs with noatime on the
remotes, or you'll be unnecessary trashing all metadata all the time.

Aaaaand, if you get a new 128MiB extent with shiny new data on day 1,
and then the remote changes 75% of it before doing backup of day 2, then
25% of the file as seen in day 2 backup might reflink to parts of the
old 128MiB extent of day 1. But, if you expire backup of day 1, that
128MiB extent just stays there, with 75% of it still keeping disk space
occupied, but not reachable from any file on your filesystem! And
balance doesn't fix that.

I have an explicit --whole-file in the rsync command because of this.
Some of the remotes do actually have changing files, which are
postgresql dumps in sqlformat compressed with gzip --rsyncable. Rsync
can combine the data of the day before and new fragments from the
remote, but I'd rather have it write out 1 new complete file again.

> What I first found was an adaptive rebalancer script which I still use
> for the main filesystem:
> 
> https://www.spinics.net/lists/linux-btrfs/msg52076.html
> (thanks to Lionel)
> 
> It works pretty well and has no such big IO overhead due to the
> adaptive multi-pass approach.

It looks that it sets a target amount of unallocated space it wants to
have, and then starts doing balance with dusage=0, 1, 2, 3, etc until
that target is reached. That's a nice way yes.

-- 
Hans van Kranenburg
