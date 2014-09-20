Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57287 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbaITUqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 16:46:11 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Holger =?ISO-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
Date: Sat, 20 Sep 2014 22:44:35 +0200
Message-ID: <1587513.UOPMuzriXx@ax5200p>
In-Reply-To: <6DB655AC-0808-4B52-840C-823B46030795@gmail.com>
References: <1411129114.1811.7.camel@zarniwoop.blob> <1678306.dObPo7E7s7@fb07-iapwap2> <6DB655AC-0808-4B52-840C-823B46030795@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

Am Samstag 20 September 2014, 22:04:16 schrieb Wang Shilong:
> Hi,
> 
> just my two cents here.^_^
> 
> > Am Freitag, 19. September 2014, 13:51:22 schrieb Holger Hoffstätte:
> >> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
> >>> I have a particularly uncomplicated setup (a desktop PC with a hard
> >>> disk) and I'm seeing particularly slow performance from btrfs.  A `git
> >>> status` in the linux source tree takes about 46 seconds after dropping
> >>> caches, whereas on other machines using ext4 this takes about 13s.  My
> >>> mail client (evolution) also seems to perform particularly poorly on
> >>> this setup, and my hunch is that it's spending a lot of time waiting on
> >>> the filesystem.
> >> 
> >> This is - unfortunately - a particular btrfs oddity/characteristic/flaw,
> >> whatever you want to call it. git relies a lot on fast stat() calls,
> >> and those seem to be particularly slow with btrfs esp. on rotational
> >> media. I have the same problem with rsync on a freshly mounted volume;
> >> it gets fast (quite so!) after the first run.
> > 
> > my favorite benchmark is "ls -l /usr/bin":
> > 
> > ext4:     0.934s
> > btrfs:   21.814s
> 
> I did a quick benchmark for this:
> 
> Testing tool is something like follows, it create 50W files
> and 50w directories under a fresh mkfs filesystem, btrfs is just
> a little slower than ext4:
> 
> For ext4:
> real	0m9.295s
> user	0m2.252s
> sys	0m7.010s
> 
> For btrfs:
> real	0m10.207s
> user	0m1.347s
> sys	0m8.353s
> 
> And test is done with a 20G vm disk(backend is hard disk) with
> latest kernel compiled under VM.

thanks for testing! However, I think a "double cached" VM disk may not be a 
good test candidate.

> #!/bin/bash
> 
> umount /dev/sdc
> #~/source/e2fsprogs/misc/mke2fs -F -O inline_data /dev/sdc >/dev/null
> mkfs.ext4 -F /dev/sdc >/dev/null
> mount /dev/sdc /mnt
> ./mdtest  -d /mnt/ext4 -n 500000 -C >&/dev/null
> echo 3 > /proc/sys/vm/drop_caches
> time ls -l /mnt/ext4/\#test-dir.0/mdtest_tree.0 >& /dev/null
> 
> umount /dev/sdc
> mkfs.btrfs -f /dev/sdc >/dev/null
> mount /dev/sdc /mnt
> ./mdtest  -d /mnt/btrfs -n 500000 -C >/dev/null
> echo 3 > /proc/sys/vm/drop_caches
> time ls -l /mnt/btrfs/\#test-dir.0/mdtest_tree.0 >& /dev/null

ok, 500000 is much more than my 5000 files in /usr/bin, so ext4 needs a bit 
more time. Also a fresh new btrfs may not reflect the same stage as an ageing 
one. Unfortunately, I haven't found a method yet to find out the fragmentation 
of a directory, so the question is why btrfs is that fast in your case ....

I did a small experiment:

mkdir /usr/bin2; cd /usr/bin2
for i in ../bin/*; do ln $i; done
echo 3 > /proc/sys/vm/drop_caches
time ls -l > /dev/null
real    0m5.935s
user    0m0.063s
sys     0m0.344s

better, so I think this is partly due to heavy fragmentation of the original 
directory where even defrag does not help, but

btrfs fi defrag bin2
echo 3 > /proc/sys/vm/drop_caches
time ls -l > /dev/null
real    0m8.059s
user    0m0.080s
sys     0m0.381s

and
btrfs fi defrag -clzo bin2
echo 3 > /proc/sys/vm/drop_caches
time ls -l > /dev/null
real    0m12.524s
user    0m0.072s
sys     0m0.461s

times are +/- 1s in repeated tests.

so defragging seems to hurt in this case.

> So here i think Btrfs is not that you think much slower than Ext4 at least
> for ‘ls’ which means directory reading performances…
> 
> Here i think you could do several ways to improve or avoid such things:
> 
> 1. create a separate subvolume or separate partition for /usr and use
> noatime mount option if possible.(I remembered Marc MARLIEN gave some good
> example for this)

I have relatime, nodiratime and also compress=lzo.

> 2. running defrag command to reduce fragmentation.

I do this once per week on all directories via a cron job:
find / -xdev -type d -print -exec btrfs filesystem defragment -c '{}' \;

> Reasons for doing these are because that directory like /usr/bin is
> regularly accessed which will also trigger Btrfs widely COWed which may
> cause serious fragmentation and that may cause some bad performances..

and compression may also not benefit it. 

> And another factor btrfs in default all files are mixed together in a a fs
> B-tree, which means that all read/write lock will walk through same tree
> which may cause some lock contention problem.
> 
> So use a separate subvoulme tree could improve lock thing a bit for that
> IMO.

well, I have /, /var, and /usr on the same partition. So not so much 
additional data (/home, /usr/src, /opt have their own partition).

> BTW, next time if someone reported some problems,it will be nice to
> give your detailed information for example kernel version, how many
> subvolumes/snapshots, btrfs file system configurations, usage(running btrfs
> file show,btrfs file df e.g.) these informations are useful for others to
> reproduce and analysis...

ok, for the sake of completness:
	no subvolumes/snapshots (but merged two partitons),
	nodiratime,relatime,compress=lzo,space_cache,autodefrag,
	kernel 3.17rc5 (+btrfsprogs 3.17.x)
	rotating media

# btrfs file show /
Label: 'root'  uuid: 7e30aa9c-a7f0-456c-96c0-ee5c009bfe71
        Total devices 2 FS bytes used 20.80GiB
        devid    1 size 23.44GiB used 23.44GiB path /dev/sda6
        devid    2 size 4.00GiB used 4.00GiB path /dev/sda10

# btrfs file df /
Data, single: total=25.40GiB, used=19.96GiB
System, single: total=32.00MiB, used=12.00KiB
Metadata, single: total=2.00GiB, used=857.67MiB
GlobalReserve, single: total=288.00MiB, used=0.00B

Regards,

Marc

