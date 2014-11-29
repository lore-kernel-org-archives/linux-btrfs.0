Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:50716 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbaK2BZc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 20:25:32 -0500
Message-ID: <54792084.6060404@pobox.com>
Date: Fri, 28 Nov 2014 17:25:24 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: kreijack@inwind.it, Zygo Blaxell <zblaxell@furryterror.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com> <546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org> <5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org> <5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org> <5474FBD9.5070709@inwind.it> <20141125222126.GQ17380@hungrycats.org> <54760B89.3050604@inwind.it> <20141127041510.GV17380@hungrycats.org> <5478AB6C.7030809@inwind.it>
In-Reply-To: <5478AB6C.7030809@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/28/2014 09:05 AM, Goffredo Baroncelli wrote:
> For the disk autodetection, I still convinced that it is a "sane" default
> to skip the lvm-snapshot

No... please don't...

Maybe offer an option to select between snapshots or no-snapshots but in 
much the same way there is no _functional_ difference between a 
subvolume and a snapshot in btrfs, there is no "degenerate" status to an 
LVM snapshot.

It would be way more useful if the helper dumped a message via stderr or 
syslog that said something like "UUID=xxxxxxxx ambiguous, must select 
between /dev/AA and /dev/BB using device= to mount filesystem."


