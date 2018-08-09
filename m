Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:57576 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbeHIUeF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 16:34:05 -0400
Date: Thu, 9 Aug 2018 19:48:11 +0200
From: Tomasz Pala <gotar@polanet.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes
 with quota
Message-ID: <20180809174811.GA27001@polanet.pl>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2018 at 22:32:07 +0800, Qu Wenruo wrote:

> 2) Different limitations on exclusive/shared bytes
>    Btrfs can set different limit on exclusive/shared bytes, further
>    complicating the problem.
> 
> 3) Btrfs quota only accounts data/metadata used by the subvolume
>    It lacks all the shared trees (mentioned below), and in fact such
>    shared tree can be pretty large (especially for extent tree and csum
>    tree).

I'm not sure about the implications, but just to clarify some things:

when limiting somebody's data space we usually don't care about the
underlying "savings" coming from any deduplicating technique - these are
purely bonuses for system owner, so he could do larger resource overbooking.

So - the limit set on any user should enforce maximum and absolute space
he has allocated, including the shared stuff. I could even imagine that
creating a snapshot might immediately "eat" the available quota. In a
way, that quota returned matches (give or take) `du` reported usage,
unless "do not account reflinks withing single qgroup" was easy to implemet.

I.e.: every shared segment should be accounted within quota (at least once).

And the numbers accounted should reflect the uncompressed sizes.


Moreover - if there would be per-subvolume RAID levels someday, the data
should be accouted in relation to "default" (filesystem) RAID level,
i.e. having a RAID0 subvolume on RAID1 fs should account half of the
data, and twice the data in an opposite scenario (like "dup" profile on
single-drive filesystem).


In short: values representing quotas are user-oriented ("the numbers one
bought"), not storage-oriented ("the numbers they actually occupy").

-- 
Tomasz Pala <gotar@pld-linux.org>
