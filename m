Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56626 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3HTJ7b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 05:59:31 -0400
Date: Tue, 20 Aug 2013 11:59:23 +0200
From: Xavier Bassery <xavier@bartica.org>
To: BJ Quinn <bj@placs.net>
Cc: psusi@cfl.rr.com, Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs@vger.kernel.org, Freddie Cash <fjwcash@gmail.com>,
        bo li liu <bo.li.liu@oracle.com>
Subject: Re: Cloning a Btrfs partition
Message-ID: <20130820115923.61d8654d@xavier-ThinkPad-T60p.lan>
In-Reply-To: <5278956.15824.1376945132989.JavaMail.root@mail.placs.net>
References: <51F79530.50006@jan-o-sch.net>
	<5278956.15824.1376945132989.JavaMail.root@mail.placs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Aug 2013 15:45:32 -0500 (CDT)
BJ Quinn <bj@placs.net> wrote:

> Ok, so the fix is now in 3.10.6 and I'm using that.  I don't get the
> hang anymore, but now I'm having a new problem.
> 
> Mount options --
> 
> rw,noatime,nodiratime,compress-force=zlib,space_cache,inode_cache,ssd
> 
> I need compression because I get a very high compression ratio with
> my data and I have lots of snapshots, so it's the only way it can all
> fit. I have an ssd and 24 cores anyway, so it should be fast. I need
> compress-force because I have lots of files in my data which compress
> typically by a 10:1 or 20:1 ratio, but btrfs likes to see them as
> incompressible, so I need the compress-force flag. I've just heard
> good things about space_cache and inode_cache, so I've enabled them.
> The ssd option is because I do have an ssd, but I have DRBD on top of
> it, and it looked like btrfs could not automatically detect that it
> was an ssd (rotation speed was showing as "1").
> 
> Using newest btrfs-progs from git, because newest shipping
> btrfs-progs on CentOS 6 returns an error for invalid argument.
> 
> I have a filesystem with maybe 1000 snapshots. They're daily
> snapshots of a filesystem that is about 24GB compressed. The total
> space usage is 323GB out of 469GB on an Intel SSD.
> 
> All the snapshots are writable, so I know I have to create a readonly
> snapshot to copy to a backup drive.

Hi BJ,

I am curious to know why you use writable snapshots instead of
read-only?
When I use snapshots as a base for backups, I create them read-only, so
that I don't need to worry something might have accidentally changed in
any of those.
I only use writable ones in cases when I actually need to write to them
(e.g. doing an experimental upgrade on a system root subvolume).
As a bonus, this would save you the need to:
1. create a ro snapshot of your rw one
2. rename the sent snapshot on the destination fs to a meaningful name.

> 
> btrfs subvolume snapshot
> -r /home/data/snapshots/storage\@NIGHTLY20101201 /home/data/snapshots\storageROTEMP
> 
> Then I send the snapshot to the backup drive, mounted with the same
> mount options.
> 
> btrfs send /home/data/snapshots/storageROTEMP | btrfs
> receive /mnt/backup/snapshots/
> 
> This takes about 5 hours to transfer 24GB compressed. Uncompressed it
> is about 150GB.  There is a "btrfs" process that takes 100% of one
> core during this 5 hour period.  There are some btrfs-endio and other
> processes that are using small amounts of more than one core, but the
> "btrfs" process always takes 100% and always only takes one core. And
> iostat clearly shows no significant disk activity, so we're
> completely waiting on the btrfs command. Keep in mind that the source
> filesystem is on an SSD, so it should be super fast. The destination
> filesystem is on a hard drive connected via USB 2.0, but again,
> there's no significant disk activity.  Processor is a dual socket
> Xeon E5-2420.

5 hours for 150GB, meaning you only get ~8MB/s to your USB2 external
HD (instead of the ~25MB/s you could expect from USB2) is indeed rather
slow. 
But as you have noticed, your bottleneck here is cpu-bound, which I
guess you find frustrating given how powerful your system is (2 x 6
cores cpu + hyperthreading = 24 threads).
Your case may illustrate the need for more parallelism...

My guess is that the poor performance stems from your choice of
'compress-force=zlib' mount option.
First, zlib compression is known to be slower than lzo while able to
give higher compression ratios. 
Secondly, 'compress-force' while giving you even better compression
means that your system will also compress already highly compressed
files (and potentially big and/or numerous).
To sum up, you have chosen space efficiency at the cost of performance
because of the lack of parallelism in this particular use case (so
your multi-core system cannot help).

> 
> Then I try to copy another snapshot to the backup drive, hoping that
> it will keep the space efficiency of the snapshots.
> 
> mv /mnt/backup/snapshots/storageROTEMP /mnt/backup/snapshots/storage\@NIGHTLY20101201
> btrfs subvolume delete /home/data/snapshots/storageROTEMP
> btrfs subvolume snapshot
> -r /home/data/snapshots/storage\@NIGHTLY20101202 /home/data/snapshots/storageROTEMP
> btrfs send /home/data/snapshots/storageROTEMP | btrfs
> receive /mnt/backup/snapshots/
> 
> This results in a couple of problems. First of all, it takes 5 hours
> just like the first snapshot did. Secondly, it takes up another ~20GB
> of data, so it's not space efficient (I expect each snapshot should
> add far less than 500MB on average due to the math on how many
> snapshots I have and how much total space usage I have on the main
> filesystem).

It is not surprising that it takes another 5 hours, because you've sent
a full copy of your new snapshot made at day+1! What you should have
done instead is :

btrfs send -p <path_of_parent_snapshot> <path_of_next_snapshot>, so in
your case that would be:

btrfs send -p [...]20101201 [...]20101202 | btrfs receive
<path_to_backup_volume>

(I have omitted your paths in the above for clarity).
For this to work, you need to use read-only dated snapshots.

> Finally, it doesn't even complete without error. I get
> the following error after about 5 hours --
> 
> At subvol /home/data/snapshots/storageROTEMP
> At subvol storageROTEMP
> ERROR: send ioctl failed with -12: Cannot allocate memory
> ERROR: unexpected EOF in stream.

I am not competent enough to explain this error.

> 
> So in the end, unless I'm doing something wrong, btrfs send is much
> slower than just doing a full rsync of the first snapshot, and then
> incremental rsyncs with the subsequent ones.  That and btrfs send
> doesn't seem to be space efficient here (again, unless I'm using it
> incorrectly).

At least you were right supposing you were not using it correctly :p

Best regards,
Xavier

