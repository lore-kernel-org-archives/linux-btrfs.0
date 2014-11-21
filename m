Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:50262 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbaKULfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 06:35:09 -0500
Message-ID: <546F2369.8090605@pobox.com>
Date: Fri, 21 Nov 2014 03:35:05 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS messes up snapshot LV with origin
References: <54699CC7.1050909@swiftspirit.co.za>	<546A46A5.8030603@inwind.it>	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>	<546B68F8.6080008@ubuntu.com>	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>	<546BA96D.4050805@ubuntu.com>	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org> <pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
In-Reply-To: <pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2014 10:22 PM, Duncan wrote:
> But while other filesystems might allow un-UUIDs (heh, UUUIDs or U3IDs
> =:^), because they're no longer unique, requiring them to be unique just
> as the label says cannot be considered a bug.  It's simply stricter
> enforcement of the rules, which are, after all, plainly stated in the
> descriptive name.

You take "U"s away, not add them

UID = unique ID
GUID = globally unique ID
UUID = universally unique ID


And other file systems have the same issues. XFS, for example uses UUIDs 
in the same way. It just has a command to re-brand the filesystem's UUID 
which you apply to the LVM snapshot immediately after taking the 
snapshot. (problem long-since established and understood since 2009 or so.)

I don't know if this approach would work for BRFS with subvolumes.

Example Citation :: 
http://www.miljan.org/main/2009/11/16/lvm-snapshots-and-xfs/

XFS also has the nouuids mount option.

btrfs has device= mount option.

But any system with unique ids will have this identical issue when 
block-snapshot support is added underneath.

-- Rob.
