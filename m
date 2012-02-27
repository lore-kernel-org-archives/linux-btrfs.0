From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: LABEL only 1 device
Date: Mon, 27 Feb 2012 16:48:34 +0000 (UTC)
Message-ID: <pan.2012.02.27.16.48.34@cox.net>
References: <20120227101154.GE18898@carfax.org.uk>
	<C3f2t9RT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen posted on Mon, 27 Feb 2012 11:27:00 +0100 as excerpted:

> Du meintest am 27.02.12:
> 
>>>>    mkfs.btrfs creates a new filesystem. The -L option sets the label
>>>> for the newly-created FS.

>>> The safest way may be deleting this option ... it seems to work as
>>> expected only when I create a new FS on 1 disk/partition.
> 
>>    I've said this several times: Your expectations are wrong. You
>> don't label partitions.
> 
> Yes - now I know.
> But I'm afraid other people also expect wrong - when I use mkfs.ext[234]
> then this option works (in another way than with "mkfs.btrfs").

AFAIK, it works in the same way... that is, it labels the, in that case, 
ext2/3/4 filesystem, in this case (mkfs.btrfs), btrfs filesystem.

>From the manpages:

mkfs.btrfs (aka mkbtrfs):

       -L, --label name
              Specify a label for the filesystem.

mkfs.ext2/3/4 (aka mke2fs):

       -L new-volume-label
              Set  the  volume  label  for the filesystem to
	      new-volume-label.  The maximum length of the
              volume label is 16 bytes.

e2label:

       e2label  will display or change the filesystem label on the
       ext2, ext3, or ext4 filesystem located on device.

mkreiserfs:

      -l | --label LABEL
              Sets   the   volume  label  of  the filesystem. LABEL
              can at most be 16 characters long; if it is longer than
              16 characters, mkreiserfs will truncate it.

reiserfstune:

       -l | --label LABEL
              Set  the  volume  label  of  the filesystem. LABEL can
              be at most 16 characters long; if it is longer than 16
              characters, reiserfstune will truncate it.

The mkswap manpage does make things a bit more confusing, until you 
realize that the "device" they're referencing is a "swap device", which 
can be a file, not just a "block device".

       mkswap sets up a Linux swap area on a device or in a file.

       [...]

       -L, --label label
              Specify a label for the device, to allow swapon by label.


fstab indicates the filesystem label:

       The first field (fs_spec).
              This field describes the block special device or remote
              filesystem to be mounted.

              For ordinary mounts it will hold (a link to) a block
              special device  node  (as  created  by mknod(8))  for
              the device to be mounted, like `/dev/cdrom' or
              `/dev/sdb7'.  [...]

              Instead of giving the device explicitly, one may
              indicate the (ext2 or xfs) filesystem that is to
              be  mounted  by its UUID or volume label (cf.
              e2label(8) or xfs_admin(8)), writing
              LABEL=<label> or UUID=<uuid>, e.g., `LABEL=Boot'[.]
              This  will  make  the  system more robust: adding
              or removing a SCSI disk changes the disk device name
              but not the filesystem volume label.

mount seems to be confused, using label in both the filesystem and device 
context (it also discusses selinux labels, etc, which are of course 
different).  I'm not going to quote it here as the bits discussing label 
are dispersed and getting context clear on all of them would take a lot 
of space.  Searching the manpage for "label" (case insensitive search) 
works, tho, again noting that it uses "label" in selinux and other 
contexts as well.

In another post I mentioned that gpt partitions do have "names", which 
/could/ function similarly to labels, tho Linux including the mount 
command generally ignores them at present.  From the gdisk (part of 
gptfdisk) manpage (the cgdisk and sgdisk manpages, same package, are 
similarly worded, including the note on the distinction between gpt 
partition name and filesystem label):

       c      Change the GPT name of a partition. This name is encoded
              as a UTF-16 string, but proper entry and display of
              anything beyond basic ASCII values requires suitable
              locale and font support. For the most part, Linux ignores
              the partition name, but it may be important in some OSes.
              GPT  fdisk sets a default name based on the partition type
              code. Note that the GPT partition name is different from
              the filesystem name, which is encoded in the filesystem's
              data structures.

Note especially that last sentence, above.


So a filesystem label is just that, a /filesystem/ label.  That there's 
normally a 1:1 correspondence between filesystem and the block device(s) 
it's on is simply an accident.  But it's NOT an accident when a btrfs 
filesystem label applies to ALL the devices that compose the filesystem, 
since it's a FILESYSTEM label, NOT a PARTITION label.  As the gptfdisk 
manpages make clear, partition names/labels, where they exist as in gpt 
based partitioning, are quite distinct from the filesystem names/labels.


However, the above manpage research does point out that while usage is 
generally quite consistent, the mkswap and mount manpages usage is 
ambiguous, and should be made more clear.

Perhaps later today I'll file bugs...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

