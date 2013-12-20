Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52602 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3LTAGb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 19:06:31 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so1833961pbc.12
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 16:06:31 -0800 (PST)
Message-ID: <52B38A05.9060407@gmail.com>
Date: Thu, 19 Dec 2013 16:06:29 -0800
From: Chris Kastorff <encryptio@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
References: <52B2BBE1.8090306@gmail.com> <724763DD-956D-4A88-A6DA-E178E246536B@colorremedies.com>
In-Reply-To: <724763DD-956D-4A88-A6DA-E178E246536B@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2013 02:21 PM, Chris Murphy wrote:
>
> On Dec 19, 2013, at 2:26 AM, Chris Kastorff <encryptio@gmail.com> wrote:
>
>> btrfs-progs v0.20-rc1-358-g194aa4a-dirty
>
> Most of what you're using is in the kernel so this is not urgent but
if it gets to needing btrfs check/repair, I'd upgrade to v3.12 progs:
> https://www.archlinux.org/packages/testing/x86_64/btrfs-progs/

Adding the testing repository is a bad idea for this machine; turning
off the testing repository is extremely error prone.

Instead, I am now using the btrfs tools from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git's
master (specifically 8cae184), which reports itself as:

deep# ./btrfs version
Btrfs v3.12

>
>> sd 0:2:3:0: [sdd] Unhandled error code
>> sd 0:2:3:0: [sdd]
>> Result: hostbyte=0x04 driverbyte=0x00
>> sd 0:2:3:0: [sdd] CDB:
>> cdb[0]=0x2a: 2a 00 26 89 5b 00 00 00 80 00
>> end_request: I/O error, dev sdd, sector 646535936
>> btrfs_dev_stat_print_on_error: 7791 callbacks suppressed
>> btrfs: bdev /dev/sdd errs: wr 315858, rd 230194, flush 0, corrupt 0,
gen 0
>> sd 0:2:3:0: [sdd] Unhandled error code
>> sd 0:2:3:0: [sdd]
>> Result: hostbyte=0x04 driverbyte=0x00
>> sd 0:2:3:0: [sdd] CDB:
>> cdb[0]=0x2a: 2a 00 26 89 5b 80 00 00 80 00
>> end_request: I/O error, dev sdd, sector 646536064
>
> These are hardware errors. And you have missing devices, or at least
> a message of missing devices. So if a device went bad, and a new one
> added without deleting the missing one, then the new device only has
> new data. Data hasn't been recovered and replicated to the
> replacement. So it's possible with a missing device that's not
> removed, and a 2nd device failure, to lose some data.
>

This is not what happened, as I explained earlier; I shall explain
again, with more verbosity:

- Array is good. All drives are accounted for, btrfs scrub runs cleanly.
btrfs fi show shows no missing drives and reasonable allocations.
- I start btrfs dev del to remove devid 9. It chugs along with no
errors, until:
- Another drive in the array (NOT THE ONE I RAN DEV DEL ON) fails, and
all reads and writes to it fail, causing the SCSI errors above.
- I attempt clean shutdown. It takes too long for because my drive
controller card is buzzing loudly and the neighbors are sensitive to
noise, so:
- I power down the machine uncleanly.
- I remove the failed drive, NOT the one I ran dev del on.
- I reboot, attempt to mount with various options, all of which cause
the kernel to yell at me and the mount command returns failure.

>From what I understand, at all points there should be at least two
copies of every extent during a dev del when all chunks are allocated
RAID10 (and they are, according to btrfs fi df ran before on the mounted
fs).

Because of this, I expect to be able to use the chunks from the (not
successfully removed) devid=9, as I have done many many times before due
to other btrfs bugs that needed unclean shutdowns during dev del.

Under the assumption devid=9 is good, if a slightly out of date on
transid (which ALL data says is true), I should be able to completely
recover all data, because data that was not modified during the deletion
resides on devid=9, and data that was modified should be redundantly
(RAID10) stored on the remaining drives, and thus should work given this
case of a single drive failure.

Is this not the case? Does btrfs not maintain redundancy during device
removal?

>> btrfs read error corrected: ino 1 off 87601116364800 (dev /dev/sdf
>> sector 62986400)
>>
>> btrfs read error corrected: ino 1 off 87601116798976 (dev /dev/sdg
>> sector 113318256)
>
> I'm not sure what constitutes a btrfs read error, maybe the device it
> originally requested data from didn't have it where it was expected
> but was able to find it on these devices. If the drive itself has a
> problem reading a sector and ECC can't correct it, it reports the
> read error to libata. So kernel messages report this with a line that
> starts with the word "exception" and then a line with "cmd" that
> shows what command and LBAs where issued to the drive, and then a
> "res" line that should contain an error mask with the actual error -
> bus error, media error. Very often you don't see these and instead
> see link reset messages, which means the drive is hanging doing
> something (probably attempting ECC) but then the linux SCSI layer
> hits its 30 second time out on the (hanged) queued command and resets
> the drive instead of waiting any longer. And that's a problem also
> because it prevents bad sectors from being fixed by Btrfs. So they
> just get worse to the point where then it can't do anything about the
> situation.

There was a single drive immediately failing all its writes and reads
because that's how the controller card was configured. No ECC failures,
no timeouts. I have hit those issues on other arrays, but the drive
controller I'm using here correctly and immediately returned errors on
requests when the drive failed. I am no stranger to SCSI error messages
on both shitty drive interfaces (which behave as you described) and
reasonable ones (like the immediate failure I saw here.)

This single drive failure is the first case of errors after the most
recent (hours before) btrfs scrub which found no errors, and btrfs fi
show showed no warnings.

>
> So I think you need to post a full dmesg somewhere rather than
> snippets. And I'd also like to see the result from smartctl -x for
> the above three drives, sdd, sdf, and sdg. And we need to know what
> this missing drive message is about, if you've done a drive
> replacement and exactly what commands you used to do that and how
> long ago.

I cannot post the full dmesg during the drive failure; since it was
gigabytes of nothing but (completely expected) SCSI errors and btrfs log
lines saying write failed, as I snipped above, journald cut the top of
it because there was too much data.

Full dmesg after reboot annotated with mount and btrfsck commands as I
ran them is at https://encryptio.com/z/btrfs-failure-dmesg.txt ; My
annotations are lines starting with #, all other lines are complete and
unmodified.

Most of the drives are on an LSI MegaRAID 9260-8i card, but it is
configured write-through and with single drive RAID0 LUNs, which is as
close to passthru as you can get. btrfs handles redundancy, NOT the
drive controller;

This filesystem was originally spread across drives not on the
controller card; I used btrfs dev add /dev/<card drive> /mnt/lake for
each of the drives followed by btrfs dev del /dev/<old drive> /mnt/lake
followed by btrfs balance start /mnt/lake to move the filesystem to the
new drives.

The raid card software (an on-boot configuration tool) shows no SMART
errors or warnings on any of the remaining drives. Unfortunately I can't
get smartctl to actually grab any data through the controller:

deep# ./smartctl -x /dev/sdf
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.12.4-1-ARCH] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

Smartctl open device: /dev/sdf failed: DELL or MegaRaid controller,
please try adding '-d megaraid,N'

deep# ./smartctl -d megaraid,0 -x /dev/sdf
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.12.4-1-ARCH] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

Smartctl open device: /dev/sdf [megaraid_disk_00] failed: INQUIRY failed

Also, the drives renumber themselves often. If you want to ask me about
a specific drive, please use the btrfs devid, which I can look up in the
currently booted device ordering.
