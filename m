Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43202 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaHRSQs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 14:16:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XJRU3-0002uG-6Z
	for linux-btrfs@vger.kernel.org; Mon, 18 Aug 2014 20:16:43 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 20:16:43 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Aug 2014 20:16:43 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Putting very big and small files in one subvolume?
Date: Mon, 18 Aug 2014 19:16:20 +0100
Message-ID: <lstftk$tmt$1@ger.gmane.org>
References: <CAH-HCWVDtPv9gYxpcA4drK=FDes_0z8QTxqOBcocWf9T_b4tyQ@mail.gmail.com> <pan$df1ba$a20420a2$2ac33113$90ec0a1@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$df1ba$a20420a2$2ac33113$90ec0a1@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good questions and already good comment given.


For another view...

On 17/08/14 13:31, Duncan wrote:
> Shriramana Sharma posted on Sun, 17 Aug 2014 14:26:06 +0530 as excerpted:
> 
>> Hello. One more Q re generic BTRFS behaviour.
>> https://btrfs.wiki.kernel.org/index.php/Main_Page specifically
>> advertises BTRFS's "Space-efficient packing of small files".
>>
>> So far (on ext3/4) I have been using two partitions for small/regular
>> files (like my source code repos, home directory with its hidden config
>> subdirectories etc) and big files (like downloaded Linux ISOs,
>> VMs etc) under some sort of understanding that this will help curb
>> fragmentation...

The cases of pathological fragmentation by btrfs (for 'database-style'
files and VM image files especially) have been mentioned, as have the
use of nocow and/or using separate subvolumes to reduce or slow down the
buildup of the fragmentation.

systemd logging even bulldozed blindly into that one spectacularly!...


There is now a defragment option. However, that does not scale well for
large or frequently rewritten files and you gamble how much IO bandwidth
you can afford to lose rewriting *entire* files.

The COW fragmentation problem is not going to go away. Also, there is
quite a high requirement for user awareness to specially mark
directories/files as nocow. And yet then, that still does not work well
if multiple snapshots are being taken...!


Could a better and more complete fix be to automatically defragment say
just x4 the size being written for a file segment?

Also, for the file segment being defragged, abandon any links to other
snapshots to in effect deliberately replicate the data where appropriate
so that data segment is fully defragged.



>> In any case, since BTRFS effectively discourages usage of separate
>> partitions to take advantage of subvolumes etc, and given the above
>> claim to the FS automatically handling small files efficiently, I wonder
>> if it makes sense any longer to create separate subvolumes for such
>> big/small files as I describe in my use case?
> 
> It's worth noting that btrfs subvolumes are a reasonably lightweight 
> construct, comparable enough to ordinary subdirectories that they're 
> presented that way when browsing a parent subvolume, and there was 
> actually discussion of making subvolumes and subdirs the exact same 
> thing, effectively turning all subdirs into subvolumes.
> 
> As it turns out that wasn't feasible due not to btrfs limitations, but 
> (as I understand it) to assumptions about subdirectories vs. mountable 
> entities (subvolumes) built into the Linux POSIX and VFS levels...

Due to namespaces and inode number spaces?...



> OTOH, I tend to be rather more of an independent partition booster than 
> many.  The biggest reason for that is the too many eggs in one basket 
> problem.  Fully separate filesystems on separate partitions...

I do so similarly myself. A good scheme that I have found to work well
for my cases is to have separate partitions for:

/boot
/var
/var/log
/
/usr
/home
/mnt/data...

And all the better and easy to do using GPT partition tables.

The one aspect to all that is that you can protect your system becoming
jammed by suffering a full disk for whatever reason and all without
needing to resort to quotas. So for example, rogue logging can fill up
/var/log and you can still use the system and be able to easily tidy
things up.

However, that scheme does also require that you have a good idea of what
partition sizes you will need right from when first set up.

You can 'cheat' and gain flexibility at the expense of HDD head seek
time by cobbling together LVM volumes as and when needed to resize
whichever filesystem.


Which is where btrfs comes into play in that if you can trust to not
lose all your eggs to btrfs corruption, you can utilise your partition
scheme with subvolumes and quotas and allow the intelligence in btrfs to
make everything work well even if you change what size (quota) you want
for a subvolume. The ENTIRE disk (no partition table) is all btrfs.

Special NOTE: Myself, I consider btrfs *quotas* to be still very
experimental at the moment and not to be used with valued data!



Other big plusses for btrfs for me are the raid and snapshots.

The killer though is for how robust the filesystem is against corruption
and random data/hardware failure.

btrfsck?


Always keep multiple backups!

Regards,
Martin





