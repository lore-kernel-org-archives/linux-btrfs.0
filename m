Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33073 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbaEHAgh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 20:36:37 -0400
Message-ID: <536AD20E.70004@fb.com>
Date: Wed, 7 May 2014 20:38:38 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need
 off it?
References: <20140507233959.GB11401@merlins.org>
In-Reply-To: <20140507233959.GB11401@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2014 07:39 PM, Marc MERLIN wrote:
> In a moment of irony, my laptop's boot SSD's btrfs fileysstem crashed
> last night with my btrfs talk slides still open on it. It went read only overnight
> but did not crash.
>
> Please tell me ASAP if you need anything off the filesystem before I recover it
> since I'm travelling, and need to bring my laptop back up to a working state
> ASAP (I'll save the irony of showing up at my talk with "Err, I can't
> give my btrfs talk, btrfs crashed on my laptop).
>
> I'm not interested in partial recovery, I have hourly backups on my
> secondary drive on my laptop (thankfully) and was able to boot from that
> drive (double thankfully). Good thing I plan ahead :)
>
> If there is something you'd like me to try to recover the filesystem
> or to get more data off it to diagnose the bug, please let me know ASAP.
>
> Otherwise, I'll just wipe it and recover from my disk backup, but
> obviously this is bad.

Hi Marc,

Looks like you're on 3.14, did this have the fixes from my git tree that 
went into 3.15-rc?

For now I'd say that if you can make a dd image of the FS, please do so. 
  Otherwise, I don't want to suck down your time right before the trip.

-chris
