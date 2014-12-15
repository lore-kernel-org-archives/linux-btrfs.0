Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:42712 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbaLOGpJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 01:45:09 -0500
Message-ID: <548E8373.8060900@pobox.com>
Date: Sun, 14 Dec 2014 22:45:07 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Nick Dimov <dimovnike@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive being very slow
References: <548E68A3.8040608@gmail.com>
In-Reply-To: <548E68A3.8040608@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2014 08:50 PM, Nick Dimov wrote:
> Hello everyone!
>
> First, thanks for amazing work on btrfs filesystem!
>
> Now the problem:
> I use a ssd as my system drive (/dev/sda2) and use daily snapshots on
> it. Then, from time to time, i sync those on HDD (/dev/sdb4) by using
> btrfs send / receive like this:
>
> ionice -c3 btrfs send -p /ssd/previously_synced_snapshot /ssd/snapshot-X
> | pv | btrfs receive /hdd/snapshots
>
> I use pv to measure speed and i get ridiculos speeds like 5-200kiB/s!
> (rarely it goes over 1miB). However if i replace the btrfs receive with
> cat >/dev/null - the speed is 400-500MiB/s (almost full SSD speed) so I
> understand that the problem is the fs on the HDD... Do you have any idea
> of how to trace this problem down?


You have _lots_ of problems with that above...

(1) your ionice is causing the SSD to stall the send every time the 
receiver does _anything_.

(1a) The ionice doesn't apply to the pipeline, it only applies to the 
command it proceeds. So it's "ionice -c btrfs send..." then pipeline 
then "btrfs receive" at the default io scheduling class. You need to 
specify it twice, or wrap it all in a script.

ionice -c 3 btrfs send -p /ssd/parent /ssd/snapshot-X |
ionice -c 3 btrfs receive /hdd/snapshots

(1b) Your comparison case is flawed because cat >/dev/null results in no 
actual IO (e.g. writing to dev-null doesn't transfer any data anywhere, 
it just gets rubber-stamped okay at the kernel method level).

(2) You probably get negative-to-no value from using ionice on the 
sending side, particularly since SSDs don't have physical heads to seek 
around.

(2a) The value of nicing your IO is trivial on the actual SATA buss, the 
real value is only realized on a rotating media where the cost of 
interrupting other-normal-process is very high because you have to seek 
the heads way over there---> when other-normal-process needs them right 
here.

(2b) Any pipeline will naturally throttle a more-left-end process to 
wait for a more-right-end process to read the data. The default buffer 
is really small, living in the neighborhood of "MAX_PIPE" so like 5k 
last time I looked. If you want to throttle this sort of transfer just 
throttle the writer. So..

btrfs send -p /ssd/parent /ssd/snapshot-X |
ionice -c 3 btrfs receive /hdd/snapshots

(3) You need to find out if you are treating things nicely on 
/hdd/snapshots. If you've hoarded a lot of snapshots on there, or your 
snapshot history is really deep, or you are using the drive for other 
purposes that are unfriendly to large allocations, or you've laid out a 
multi-drive array poorly, then it may need some maintenance.

(3a) Test the raw receive throughput if you have the space to share. To 
do this save the output of btrfs send to a file with -f some_file. Then 
run the receive with -f some_file. Ideally some_file will be on yet a 
third media, but it's okay if its on /hdd/snapshot somewhere. Watch the 
output of iotop or your favorite graphical monitoring daemon. If the 
write throughput is suspiciously low you may be dealing with a 
fragmented filesystem.

(3b) If /hdd/snapshots is a multi-device filesystem and you are using 
"single" for data extents, try switching to RAID0. It's just as _unsafe_ 
as "single" but its distributed write layout will speed up your storage.

(4) If your system is busy enough that you really need the ionice, you 
likely just need to really re-think your storage layouts and whatnot.

(5) Remember to evaluate the secondary system effects. For example If 
/hdd/snapshots is really a USB attached external storage unit, make sure 
it's USB3 and so is the port you're plugging it into. Make sure you 
aren't paging/swapping in the general sense (or just on the cusp of 
doing so) as both of the programs are going to start competing with your 
system for buffer cache and whatnot. A "nearly busy" system can be 
pushed over the edge into thrashing by adding two large-IO tasks like these.

(5b) Give /hdd/snapshots the once-over with smartmontools, especially if 
it's old, to make sure its not starting to have read/write retry delays. 
Old disks can get "slower" before the get all "failed".

And remember, you may not be able to do squat about your results. If you 
are I/O bound, and you just _can't_ bear to part wiht some subset of 
your snapshot hoard for any reason (e.g. I know some government programs 
with hellish retention policies), then you might just be living the 
practical outcome of your policies and available hardware.


