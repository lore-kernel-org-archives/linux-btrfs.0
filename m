Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:57510 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065AbaJ2XHi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 19:07:38 -0400
Message-ID: <54517338.7090606@pobox.com>
Date: Wed, 29 Oct 2014 16:07:36 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Zack Coffey <tech42.clickwir@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com>
In-Reply-To: <5451699B.4020507@pobox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/29/2014 03:26 PM, Robert White wrote:
> On 10/28/2014 01:32 PM, Zack Coffey wrote:
>> Made a RAID1 with another drive of just the metadata. Was in
>> that state for less than 12 hours-ish, removed the second drive and
>> now cannot get to any data on the original drive. Data remained single
>> while only metadata was RAID1.
>
> I don't know all the details but I would _never_ suspect the action you
> described to _not_ hose up the file system.
> You need to put the second drive back in and then coerce all the data
> back to the first drive. "btrfs device delete" is what you want. You
> _may_ need to switch the metadata back to "single" before the delete.
>
> --Rob.
>

P.S. I am/was assuming you said "removed the second drive" in the normal 
sense of disconnecting and removing, as opposed to the semantic action 
of deleting the device element.

If you did do the btrfs delete, you might have needed to do a "btrfs 
filesystem sync" to make sure that all the transactions involved in the 
delete were finished and flushed to disk.

Either way, physically reattaching "the second drive" is your first 
step; presuming again that you haven't destroyed the partition or 
re-used the drive etc. If the partition will mount once the second drive 
is in place, do the delete operation (if you didn't) and then the sync 
(to make sure that everything has finished migrating etc). Then you 
should be able to re-remove the physical drive.

If you already did the delete and sync as part of what you meant by 
"remove" then sorry for the interruption of your misery. 8-)

