Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:55008
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727071AbeIPSNX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 14:13:23 -0400
Subject: Re: Move data and mount point to subvolume
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Rory Campbell-Lange <rory@campbell-lange.net>, linux-btrfs@vger.kernel.org
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
Message-ID: <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
Date: Sun, 16 Sep 2018 14:50:04 +0200
MIME-Version: 1.0
In-Reply-To: <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2018 02:37 PM, Hans van Kranenburg wrote:
> On 09/16/2018 01:14 PM, Rory Campbell-Lange wrote:
>> Hi
>>
>> We have a backup machine that has been happily running its backup
>> partitions on btrfs (on top of a luks encrypted disks) for a few years.
>>
>> Our backup partition is on /bkp which is a top level subvolume. 
>>     Data, RAID1: total=2.52TiB, used=1.36TiB
>> There are no other subvolumes.
>>
>> We have /bkp with /bkp/backup in it. We would like to mount /bkp/backup
>> at /bkp instead. Note that /bkp/backup has a lot of hardlinked files.
>>
>> I guess I could do 
>>
>>     cd /bkp/backup
>>     mv * ../
>>     rmdir backup
> 
> Doing it the other way around is easier, since you don't have to think
> about hardlinked/reflinked/etc/anything while copying data:

Oh wait, I'm stupid, I was reading too quickly. Let me finish my coffee
first.

> btrfs sub snap /bkp /bkp/backup
> 
> Now you have the exact identical thing in /backup, and you can start
> throwing away everything outside of /backup.
> 
> To reduce chance for accidental errors, you can snapshot with -r to make
> the new /backup read-only first. Then after removing everything outside
> it, make it rw again with:
> 
> btrfs property set -ts /bkp/backup ro false
> 
>> But would it also be possible to do something like
>>
>>     cd /bkp
>>     btrfs subvol create backup-subvol
>>     mv /bkp/backup/* /bkp/backup-subvol
>>     ... then mount /bkp/backup-subvol at /bkp
>>
>> Would this second approach work, and preserve hardlinks?

You essentially want to turn a subdirectory into a subvolume.

The last example, where you make a subvolume and move everything into
it, will not do what you want. Since a subvolume is a separate new
directoty/file hierarchy, mv will turn into a cp and rm operation
(without warning you) probably destroying information about data shared
between files.

So, what you can do is (similar to what I earlier typed):

* You now have subvol 5 (at /bkp)
* btrfs sub snap /bkp /bkp/backup-subvol
* Now you have a new subvol (256 or higher number) which already
contains everything
* Then inside /bkp/backup-subvol you will again see
/bkp/backup-subvol/backup (since you snapshotted the toplevel which also
contains it)
* Now mv /bkp/backup/backup-subvol/* /bkp/backup-subvol (so the mv
operations stays within the same subvolume)
* Then remove everything outside /bkp/backup-subvol and mv
/bkp/backup-subvol /bkp/backup, and then voila... you can now use
subvol=/backup to mount it.

>> The machine is btrfs-progs v4.7.3 Linux 4.9.0-8-amd64 on Debian. The
>> coreutils version is 8.26-3.
> 
> Another note: since it seems you have about 100% more data space
> allocated (set apart for data purpose) than you're actually using, or in
> other words, having the 1GiB chunks on average just for 50% filled...
> 
>    Data, RAID1: total=2.52TiB, used=1.36TiB
> 
> ...in combination with using Linux 4.9, I suspect there's also 'ssd' in
> your mount options (not in fstab, but enabled by btrfs while mounting,
> see /proc/mounts or mount command output)?
> 
> If so, this is a nice starting point for more info about what might also
> be happening to your filesystem:
> https://www.spinics.net/lists/linux-btrfs/msg70622.html


Have fun,


-- 
Hans van Kranenburg
