Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phd-imap.ethz.ch ([129.132.80.51]:59252 "EHLO phd-imap.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaKMTHW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 14:07:22 -0500
Message-ID: <54650166.1090800@phys.ethz.ch>
Date: Thu, 13 Nov 2014 20:07:18 +0100
From: Patrick Schmid <schmid@phys.ethz.ch>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: soft lockup - CPU#0 stuck - Kernel 3.17.2
References: <5464B2DB.7070008@phys.ethz.ch> <1415890157.25389.3@mail.thefacebook.com>
In-Reply-To: <1415890157.25389.3@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/13/2014 03:49 PM, Chris Mason wrote:
>
>
> On Thu, Nov 13, 2014 at 8:32 AM, Patrick Schmid <schmid@phys.ethz.ch>
> wrote:
>> Hi all,
>>
>> we run a > 500 TiB backup system on iSCSI targets using 19 BTRFS
>> filesystems (the biggest of which is 110 TiB) on Ubuntu 14.04 LTS and
>> various kernel versions. Btrfs-Progs v3.17.1. The hardware is a 24
>> core
>> Xeon E5-2620 on an Intel S2600GZ board with 128 GiB RAM.
>>
>> Since btrfs has changed to kworkers (I think in 3.15) the frontend
>> server somewhat randomly crashes with soft lockups (see attachment).
>> The
>> system is rock solid with the 3.14.22 kernel.
>>
>> The lockups happen during the nightly cron-controlled rsync backups
>> and
>> occur at random times during this process.
>> We are totally aware of the fact that this tends to be one of
>> those â€œit doesnâ€™t workâ€ bug reports, but
>> itâ€™s really hard to pin
>> down the source of the problem other than it seems to be related to
>> the
>> kworkers. Weâ€™d love to provide any feedback we can, please let
>> us know
>> what you need.
>
> Hi,
>
> This may actually be related to a different btrfs change in the 3.15
> kernel.  Do you see more than one soft lockup?  After the softlockup,
> does the box recover or is it stuck forever?
>
> -chris
>

Hi Chris

"Normaly" are there more than one soft lockup and the load goes up to 
sky and the server stuck forever until hard reset.

If you want, i send you tomorrow morning the whole kernel log?

regards
Patrick
