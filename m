Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-lucinda.wadns.net ([196.220.39.179]:21654 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755939AbaDKKjo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 06:39:44 -0400
Message-ID: <5347C663.4050704@swiftspirit.co.za>
Date: Fri, 11 Apr 2014 12:39:31 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Michael Schuerig <michael.lists@schuerig.de>, linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
References: <4783411.VVGoQz5kVU@fuchsia>
In-Reply-To: <4783411.VVGoQz5kVU@fuchsia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Michael

Btrfs send/receive can transfer incremental snapshots as well - you're 
looking for the "-p" or "parent" parameter. On the other hand, it might 
not be the right tool for the job.

If you're 100% happy with your old disk's *content*/layout/etc (just not 
happy with the disk's reliability), try an overnight/over-weekend 
ddrescue instead:
http://www.forensicswiki.org/wiki/Ddrescue

What I've done in the past is scripted ddrescue to recover as much data 
as possible. Its like using dd between two disks except that it can keep 
a log of bad sectors that can be retried later. The log also helps by 
ensuring that if you cancel the operation, you can start it again and it 
will continue where it left off.

Additionally, you can have it skip big sections of the disk when it 
comes across bad sectors - and it can "trim" these sections on 
subsequent runs.

Btrfs send/receive has the advantage that you can run it while your 
system is still active. DDrescue has the advantage that it is very good 
at recovering 99% of your data where a disk has lots of bad sectors.

For btrfs, send/receive the main subvolumes then, afterward, 
send/receive the snapshots using the "parent" parameter, "-p". There 
*is* the possibility that this needs to be reversed - as in, the backup 
should be treated as the parent instead of the other way around:

  btrfs send /home | btrfs receive /mnt/new-disk/home
  btrfs send -p /home /backups/home-2014-04-08 | btrfs receive 
/mnt/new-disk/backups/.

____

Below is from the last scriptlet I made when I last did the ddrescue 
route (in that case I was recovering a failing NTFS drive). It was 
particularly bad and took a whole weekend to recover. The new disk 
worked flawlessly however. :)

How I've used ddrescue in the past is to connect the failing and new 
disk to a server. Alternatively, using USB, you could boot from a rescue 
CD/flash drive and do the rescue there.

a) Identify the disks in /dev/disk/by-<whatever-you-choose> and put 
those values into the bash script below. ensure that it refers to the 
disk as a whole (not a partition for example). This ensures that 
re-ordering of the drives after a reboot won't affect the process.
b) Set up a log file location on a separate filesystem - a flash drive 
is ideal unless you've gone the "server" route, where I normally just 
put the log into a path on the the server as so: 
/root/brendan-laptop.recovery.log

#!/bin/bash
src_disk=/dev/disk/by-id/ata-ST3250410AS_6RYF5NP7
dst_disk=/dev/disk/by-id/ata-ST3500418AS_9VM2ZZQS
#log=/path/to/log
log=~/brendan-laptop.recovery.log

#Sector size (default is 512 - newer disks should probably be 4096)
sector_size=4096

#Force writing to a block device - disable if you're backing up to an 
image file
#force=""
force="-f"

# We want to skip bigger chunks to get as much data as possible before 
the source disk really dies
# For the same reason, we also want to start with (attempting) to 
maintain a high read rate
#Minimum read rate in MB/s before skipping
min_readrate=10485760


#Default skip size is 64k.
for skip_size in 65536 16384; do
  #Going forward
  ddrescue -r 1 -a $min_readrate -b $sector_size -d $force -K $skip_size 
$src_disk $dst_disk $log
  #Going in reverse
  ddrescue -r 1 -a $min_readrate -b $sector_size -d $force -K $skip_size 
-R $src_disk $dst_disk $log
done

#Default skip size is 64k.
#This time re-trying all failed/skipped sections
for skip_size in 4096; do
  #Going forward
  ddrescue -r 1 -a $min_readrate -b $sector_size -d $force -K $skip_size 
-A $src_disk $dst_disk $log
  #Going in reverse
  ddrescue -r 1 -a $min_readrate -b $sector_size -d $force -K $skip_size 
-R -A $src_disk $dst_disk $log
done

#Default skip size is 64k.
for skip_size in 1024 256 64 ; do
  #Going forward
  ddrescue -r 1 -b $sector_size -d $force -K $skip_size $src_disk 
$dst_disk $log
  #Going in reverse
  ddrescue -r 1 -b $sector_size -d $force -K $skip_size -R $src_disk 
$dst_disk $log
done

echo "Done. Run an chkdsk/fsck/whatever-might-be appropriate for the new 
disk's filesystem(s)"


On 10/04/14 15:21, Michael Schuerig wrote:
> SMART indicates that my notebook disk may soon be failing (an
> unreadable/uncorrectable sector), therefore I intend to exchange it. The
> disk contains a single btrfs filesystem with several nested(!)
> subvolumes, each with several read-only snapshots in a .snapshots
> subdirectory.
>
> As far as I can tell, btrfs currently does not offer a sensible way to
> duplicate the entire contents of the old disk onto a new one. I can use
> cp, rsync, or send/receive to copy the "main" subvolumes. But unless I'm
> missing something obvious, the snapshots are effectively lost. btrfs
> send optionally takes multiple clone sources, but I've never seen an
> example of its usage.
>
> If that's what "experimental" means, I'm willing to accept it. However,
> I'd like to emphasize that there's still something missing. Of course,
> most of all I'd like to be proved wrong.
>
> Michael
>


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

