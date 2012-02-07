From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Mon, 6 Feb 2012 21:39:45 -0600
Message-ID: <20120207033945.GA5639@localhost.localdomain>
References: <20120205184128.GC18806@localhost.localdomain>
Reply-To: nemesis@icequake.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120205184128.GC18806@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


Does anyone have any idea how I should proceed with the below quoted
situation?  Unfortunately, I am going to have to give up on btrfs if
it is really so fragile.  I am using kernel 3.2.2 and btrfs-tools
from November.

On Sun, Feb 05, 2012 at 12:41:28PM -0600, Ryan C. Underwood wrote:
> 
> Hi,
> 
> I had a RAID5 double disk failure (40 megs or so bad sectors near
> middle of the second failed disk), bad news but I recovered what I was
> able to.
> 
> The RAID contained a dm-crypt physical volume which then contained
> four logical volumes.  Two are EXT4 and two BTRFS, about 1TB in size
> each.
> 
> The failure occurred while the volumes were online and in use, so in
> addition to what was unreadable, all pending writes to the device
> between the failure and when the problem was discovered were lost as
> well.
> 
> The two ext4, fortunately, had some relatively minor corruption which
> was cleared up with a few rounds of fsck.  The two btrfs are
> completely unhappy though and I do not know how to proceed, since
> btrfs problems are new to me.  Any suggestions are welcome.
> 
> Here is the basic picture of what is going on.
> 
> # cat /etc/fstab
> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> #/dev/mapper/tr5ut-media        /mnt/media      btrfs
> defaults,compress=lzo,space_cache 0       2
> 
> /dev/mapper/tr5ut-media /mnt/media      ext4 defaults 0 2
> 
> /dev/mapper/tr5ut-vicep--library        /vicepa auto
> defaults,compress=lzo,space_cache  0       2
> 
> /dev/mapper/tr5ut-vicep--clones         /vicepb auto
> defaults,compress=lzo,space_cache  0       2
> 
> 
> You can see that btrfs device scan does not find anything, while
> btrfs-show finds one of the volumes and not the other.  Fscking the
> found volume halts due to checksum and assertion errors, while fscking
> the other volume fails completely, I guess due to a missing
> 'superblock' type structure?
> 
> 
> seraph:~# btrfs device scan
> Scanning for Btrfs filesystems
> failed to read /dev/sr0
> 
> 
> seraph:~# btrfs-show
> **
> ** WARNING: this program is considered deprecated
> ** Please consider to switch to the btrfs utility
> **
> failed to read /dev/sr0: No medium found
> Label: vicep-library  uuid: 89b14d35-b31a-4fbe-a2d9-cb83cbcd3851
>         Total devices 1 FS bytes used 254.35GB
>         devid    1 size 1.00TB used 299.04GB path /dev/dm-32
> 
> Btrfs Btrfs v0.19
> 
> 
> seraph:~# btrfsck /dev/mapper/tr5ut-vicep--library
> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
> checksum verify failed on 317874630656 wanted 491D9C1A found FFFFFFA6
> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
> Csum didn't match
> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
> `!(path->slots[0] == 0)' failed.
> Aborted
> 
> 
> seraph:~# btrfsck /dev/mapper/tr5ut-vicep--clones
> No valid Btrfs found on /dev/mapper/tr5ut-vicep--clones
> 
> 
> seraph:~# dpkg -l btrfs-tools
> Desired=Unknown/Install/Remove/Purge/Hold
> |
> Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
> |/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
> ||/ Name                                          Version
> Description
> +++-=============================================-=============================================-==========================================================================================================
> ii  btrfs-tools                                   0.19+20111105-2
> Checksumming Copy on Write Filesystem utilities
> 
> 
> -- 
> Ryan C. Underwood, <nemesis@icequake.net>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Ryan C. Underwood, <nemesis@icequake.net>
