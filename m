Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:42413 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757750AbaLLBKS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 20:10:18 -0500
Message-ID: <548A4077.3060704@pobox.com>
Date: Thu, 11 Dec 2014 17:10:15 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC after conversion [Was: Fixing Btrfs Filesystem Full Problems
 typo?]
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>	<54896F65.20708@pobox.com> <CAA7pwKNTS770TZ9ENxMMQA9-50tfrr2aRb5BWJRFheVy9NOWtQ@mail.gmail.com>
In-Reply-To: <CAA7pwKNTS770TZ9ENxMMQA9-50tfrr2aRb5BWJRFheVy9NOWtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TL;DR version

On 12/11/2014 03:01 PM, Patrik Lundquist wrote:
> Of course the filesystem is in a problematic state after the
> conversion, even if it's not a bug. ~1.5TB of free space and yet out
> of space and it can't be fixed with a balance. It might not be wrong
> per se but it's very problematic from a user perspective.

The file system is not in a problematic state, you just don't understand 
the state its in. It has ~1.5TB of space for files. Storing files is why 
we have filesystems after all.

> $ df
> Filesystem      1K-blocks       Used  Available Use% Mounted on
> /dev/sdc1      2930265088 1402223656 1526389096  48% /mnt

There it is, ~1.5TB of available space.

That space is available for files. So no problem.

So it's not "out of space" at all. Go ahead and make a couple thousand 
files of various sizes, you'll see. Lots of space.

Since it's not broken there is nothing for balance to "fix". The fact 
that balance tells you it doesn't have enough space to juggle filesystem 
bits HAS NOTHING TO DO with the file system's ability to store files.

You might as well be complaining that your hard disk is unfixable 
because you don't have enough space to add another partition.

Apples and Polar Bears. The "out of space" is only a problem in your 
head. At the same level of abstraction the EXT4 file system partition 
was "out of space" before you started the conversion because all of the 
partition was filled up with EXT4 structures.

No matter how many times you try to turn this into a "bug" it's just 
_not_ a bug. Rewording it doesn't change the facts. The _file_ _system_ 
isn't "out of space" it's just filled its partition with BTRFS extents 
enough to cause some extents to be skipped during balance.

Nothing to see here, move along. 8-)

