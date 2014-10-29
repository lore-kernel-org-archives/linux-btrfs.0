Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:47574 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757569AbaJ2W0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 18:26:36 -0400
Message-ID: <5451699B.4020507@pobox.com>
Date: Wed, 29 Oct 2014 15:26:35 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Zack Coffey <tech42.clickwir@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com>
In-Reply-To: <544FFD52.6010604@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/28/2014 01:32 PM, Zack Coffey wrote:
> Made a RAID1 with another drive of just the metadata. Was in
> that state for less than 12 hours-ish, removed the second drive and
> now cannot get to any data on the original drive. Data remained single
> while only metadata was RAID1.

I don't know all the details but I would _never_ suspect the action you 
described to _not_ hose up the file system.

The "single" mode is not "restrict to one drive" its concatenation, as 
in treat the entire space as if it were a single drive.

In that twelve hour window data migrated. I _think_ directories may 
count as data in this sense. If a key element (say the root directory) 
migrated onto the disk you eventually removed then there is no root 
directory to read. And if not root, then any secondary directory you choose.

So sure your checksum trees and your extent maps were all duplicated in 
the mirror, but your actual data -- you know all those files that were 
copied on write -- may well be only on that second drive you pulled out.

RAID metadata, and non RAID1 data, would not safely allow for failure 
(or removal) of one drive.

I'm not sure what you expected to happen but what you did is full of fail.

You need to put the second drive back in and then coerce all the data 
back to the first drive. "btrfs device delete" is what you want. You 
_may_ need to switch the metadata back to "single" before the delete.

--Rob.
