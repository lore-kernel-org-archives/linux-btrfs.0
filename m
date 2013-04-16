Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:55829 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab3DPLfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 07:35:41 -0400
Message-ID: <516D378A.6010405@arcor.de>
Date: Tue, 16 Apr 2013 13:35:38 +0200
From: Ochi <ochi@arcor.de>
MIME-Version: 1.0
To: sander@humilis.net
CC: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: Activating space_cache after read-only snapshots without space_cache
 have been taken
References: <516C9B43.7040605@arcor.de> <20130416031141.GB22531@liubo.jp.oracle.com> <20130416081023.GA24920@panda>
In-Reply-To: <20130416081023.GA24920@panda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/16/2013 10:10 AM, Sander wrote:
> Liu Bo wrote (ao):
>> On Tue, Apr 16, 2013 at 02:28:51AM +0200, Ochi wrote:
>>> The situation is the following: I have created a backup-volume to
>>> which I regularly rsync a backup of my system into a subvolume.
>>> After rsync'ing, I take a _read-only_ snapshot of that subvolume
>>> with a timestamp added to its name.
>>>
>>> Now at the time I started using this backup volume, I was _not_
>>> using the space_cache mount option and two read-only snapshots were
>>> taken during this time. Then I started using the space_cache option
>>> and continued doing snapshots.
>>>
>>> A bit later, I started having very long lags when unmounting the
>>> backup volume (both during shutdown and when unmounting manually). I
>>> scrubbed and fsck'd the volume but this didn't show any errors.
>>> Defragmenting the root and subvolumes took a long time but didn't
>>> improve the situation much.
>>
>> So are you using '-o nospace_cache' when creating two RO snapshots?
>
> No, he first created two ro snapshots, then (some time later) mounted
> with nospace_cache, and then continued to take ro snapshots.

I need to clarify this: The NOspace_cache option was never used, I just 
didn't explicitly activate space_cache in the beginning. However, I was 
not aware that space_cache is the default anyways (at least in Arch 
which is the distro I'm using). I reviewed old system logs and it 
actually looks like space caching was always being used right from the 
beginning, even when I didn't explicitly use the space_cache mount 
option. So I guess this wasn't the problem after all :\

>>> Now I started having the suspicion that maybe the space cache
>>> possibly couldn't be written to disk for the readonly
>>> subvolumes/snapshots that were created during the time when I wasn't
>>> using the space_cache option, forcing the cache to be rebuilt every
>>> time.
>>>
>>> Clearing the cache didn't help. But when I deleted the two snapshots
>>> that I think were taken during the time without the mount option,
>>> the unmounting time seems to have improved considerably.
>>
>> I don't know why this happens, but maybe you can observe the umount
>> process's very slow behaviour by using 'cat /proc/{umount-pid}/stack'
>> or 'perf top'.
>
> AFAIUI the problem is not there anymore, but this is a good tip for the
> future.
>
> 	Sander

That's correct, the problem has vanished after the deletion of the 
oldest two snapshots. Mounting and unmounting is reasonably fast now. I 
will just continue to use the volume normally (i.e. making regular 
backups and snapshotting) and report back if the problem appears again.

Just for the records: The btrfs volume and the first snapshots were 
originally created under kernel 3.7.10. I then updated to 3.8.3. I don't 
know if this information is useful - just in case... :)

Thanks,
Sebastian

