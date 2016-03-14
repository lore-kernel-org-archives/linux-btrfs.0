Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36449 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbcCNUjx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 16:39:53 -0400
Received: by mail-lb0-f175.google.com with SMTP id x1so255670692lbj.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 13:39:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160314200546.GG2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
	<20160314120703.GD2334@torres.zugschlus.de>
	<CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
	<20160314200546.GG2334@torres.zugschlus.de>
Date: Mon, 14 Mar 2016 21:39:51 +0100
Message-ID: <CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Henk Slager <eye1tm@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> BTW, I restored and mounted your 20160307-fanbtr-image:
>>
>> [266169.207952] BTRFS: device label fanbtr devid 1 transid 22215732 /dev/loop0
>> [266203.734804] BTRFS info (device loop0): disk space caching is enabled
>> [266203.734806] BTRFS: has skinny extents
>> [266204.022175] BTRFS: checking UUID tree
>> [266239.407249] attempt to access beyond end of device
>> [266239.407252] loop0: rw=1073, want=715202688, limit=705760000
>> [266239.407254] BTRFS error (device loop0): bdev /dev/loop0 errs: wr
>> 1, rd 0, flush 0, corrupt 0, gen 0
>> [266239.407272] attempt to access beyond end of device
>> .. and 16 more
>>
>> As a quick fix/workaround, I truncated the image to 1T
>
> The original fs was 417 GiB in size. What size does the image claim?

ls -alFh  of the restored image showed 337G I remember.
btrfs fi us showed also a number over 400G, I don't have the
files/loopdev anymore.
It could some side effect of btrfs-image, I only have used it for
multi-device, where dev id's are ignore, but total image size did not
lead to problems.

> [10/509]mh@fan:~$ sudo btrfs check /media/tempdisk/
> Superblock bytenr is larger than device size
> Couldn't open file system
> [11/509]mh@fan:~$
>
> Can this be fixed?

What I would do in order to fix it, is resize the fs to let's say
190GiB. That should write correct values to the superblocks I /hope/.
And then resize back to max.
Maybe btrfs check --repair can also fix it, but before doing --repair
or other actions, I would see what else besides btrfs could be wrong,
see also suggestion of Holger. --repair can repair certain things, but
also destroy the fs.
