Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43596 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752852Ab3LTDrY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 22:47:24 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52B38A05.9060407@gmail.com>
Date: Thu, 19 Dec 2013 20:47:22 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <A2FBF80C-4BD4-43CD-ACA2-A2125027E701@colorremedies.com>
References: <52B2BBE1.8090306@gmail.com> <724763DD-956D-4A88-A6DA-E178E246536B@colorremedies.com> <52B38A05.9060407@gmail.com>
To: Chris Kastorff <encryptio@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 19, 2013, at 5:06 PM, Chris Kastorff <encryptio@gmail.com> wrote:

> On 12/19/2013 02:21 PM, Chris Murphy wrote:
>> 
>> On Dec 19, 2013, at 2:26 AM, Chris Kastorff <encryptio@gmail.com> wrote:
>> 
>>> btrfs-progs v0.20-rc1-358-g194aa4a-dirty
>> 
>> Most of what you're using is in the kernel so this is not urgent but
> if it gets to needing btrfs check/repair, I'd upgrade to v3.12 progs:
>> https://www.archlinux.org/packages/testing/x86_64/btrfs-progs/
> 
> Adding the testing repository is a bad idea for this machine; turning
> off the testing repository is extremely error prone.
> 
> Instead, I am now using the btrfs tools from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git's
> master (specifically 8cae184), which reports itself as:
> 
> deep# ./btrfs version
> Btrfs v3.12

Good. As I thought about it again, you're using user space tools to add, remove, replace devices also, and that code has changed too, so better to use current.

> - Array is good. All drives are accounted for, btrfs scrub runs cleanly.
> btrfs fi show shows no missing drives and reasonable allocations.
> - I start btrfs dev del to remove devid 9. It chugs along with no
> errors, until:
> - Another drive in the array (NOT THE ONE I RAN DEV DEL ON) fails, and
> all reads and writes to it fail, causing the SCSI errors above.
> - I attempt clean shutdown. It takes too long for because my drive
> controller card is buzzing loudly and the neighbors are sensitive to
> noise, so:
> - I power down the machine uncleanly.
> - I remove the failed drive, NOT the one I ran dev del on.
> - I reboot, attempt to mount with various options, all of which cause
> the kernel to yell at me and the mount command returns failure.

devid 9 is "device delete" in-progress, and while that's occurring devid 15 fails completely. Is that correct?

Because previously you reported, in part this:
       devid   15 size 1.82TB used 1.47TB path /dev/sdd
       *** Some devices missing

And this:

sd 0:2:3:0: [sdd] Unhandled error code

That why I was confused. It looks like dead/missing device is one devid, and then devid 15 /dev/sdd is also having hardware problems - because all of this was posted at the same time. But I take it they're different boots and the /dev/sdd's are actually two different devids.

So devid 9 was "deleted" and then devid 14 failed. Right? Lovely when /dev/sdX changes between boots.


> From what I understand, at all points there should be at least two
> copies of every extent during a dev del when all chunks are allocated
> RAID10 (and they are, according to btrfs fi df ran before on the mounted
> fs).
> 
> Because of this, I expect to be able to use the chunks from the (not
> successfully removed) devid=9, as I have done many many times before due
> to other btrfs bugs that needed unclean shutdowns during dev del.

I haven't looked at the code or read anything this specific on the state of the file system during a device delete. But my expectation is that there are 1-2 chunks available for writes. And 2-3 chunks available for reads. Some writes must be only one copy because a chunk hasn't yet been replicated elsewhere, and presumably the device being "deleted" is not subject to writes as the transid also implies. Whereas devid 9 is one set of chunks for reading, those chunks have pre-existing copies elsewhere in the file system so that's two copies. And there's a replication in progress of the soon to be removed chunks. So that's up to three copies.

Problem is that for sure you've lost some chunks due to the failed/missing device. Normal raid10, it's unambiguous whether we've lost two mirrored sets. With Btrfs that's not clear as chunks are distributed. So it's possible that there are some chunks that don't exist at all for writes, and only 1 for reads. It may be no chunks are in common between devid 9 and the dead one. It may be only a couple of data or metadata chunks are in common.



> 
> Under the assumption devid=9 is good, if a slightly out of date on
> transid (which ALL data says is true), I should be able to completely
> recover all data, because data that was not modified during the deletion
> resides on devid=9, and data that was modified should be redundantly
> (RAID10) stored on the remaining drives, and thus should work given this
> case of a single drive failure.
> 
> Is this not the case? Does btrfs not maintain redundancy during device
> removal?

Good questions. I'm not certain. But the speculation seems reasonable, not accounting for the missing device. That's what makes this different.



>>> btrfs read error corrected: ino 1 off 87601116364800 (dev /dev/sdf
>>> sector 62986400)
>>> 
>>> btrfs read error corrected: ino 1 off 87601116798976 (dev /dev/sdg
>>> sector 113318256)
>> 
>> I'm not sure what constitutes a btrfs read error, maybe the device it
>> originally requested data from didn't have it where it was expected
>> but was able to find it on these devices. If the drive itself has a
>> problem reading a sector and ECC can't correct it, it reports the
>> read error to libata. So kernel messages report this with a line that
>> starts with the word "exception" and then a line with "cmd" that
>> shows what command and LBAs where issued to the drive, and then a
>> "res" line that should contain an error mask with the actual error -
>> bus error, media error. Very often you don't see these and instead
>> see link reset messages, which means the drive is hanging doing
>> something (probably attempting ECC) but then the linux SCSI layer
>> hits its 30 second time out on the (hanged) queued command and resets
>> the drive instead of waiting any longer. And that's a problem also
>> because it prevents bad sectors from being fixed by Btrfs. So they
>> just get worse to the point where then it can't do anything about the
>> situation.
> 
> There was a single drive immediately failing all its writes and reads
> because that's how the controller card was configured. 

OK so my next confusion stems from the error corrected messages above. I kinda expect error message to report the device with the error. But this seems to rather be an informational message that a read error was successfully correct, operations are normal. If so, that means /dev/sdf and /dev/sdg are the devices the recovered data came from?

> 
> Full dmesg after reboot annotated with mount and btrfsck commands as I
> ran them is at https://encryptio.com/z/btrfs-failure-dmesg.txt ;

Off topic:

This:
[    0.866365] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
[    0.866372] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff8807f3ca1460), AE_NOT_FOUND (20130725/psparse-536)
 
leads to these two:
https://bugzilla.redhat.com/show_bug.cgi?id=491588

http://markmail.org/message/eiodqm526mtejbpj#mid:srmaa4qaqkucz4gf+state:results

It suggests updating BIOS. Although nothing newer or in combination with 9260-8i…


Back to topic:

You have one missing/dead device. And devid 9 which was requested for 'device delete' but are uncertain about its state, whether the in-progress "delete" was halted upon another drive dying.

The chunks from the missing/dead drive are not automatically replicated. You need to use 'btrfs device delete missing' or you need to use 'btrfs replace' which is a newish command:

http://lwn.net/Articles/524589/

And then once that's complete it seems like you should be able to try deleting devid 9 again.

So where you're at now is you need a way to successfully mount the file system with -o degraded, not ro, so that you can successfully issue those commands, which I wouldn't expect work with an ro file system. But the problem is that you get a open_ctree failed message.

Next steps:

1. btrfs-image -c 9 -t <#cores> (see man page)
This is optional but one of the devs might want to see this because it should be a more rare case that either normal mount fix ups or additional recovery fix ups can't deal with this problem.

2. btrfs-zero-log <dev>
What's the full result from btrfs check <device>?

3. Try to mount again with -o degraded,recovery and report back.


> The raid card software (an on-boot configuration tool) shows no SMART
> errors or warnings on any of the remaining drives. Unfortunately I can't
> get smartctl to actually grab any data through the controller:

Hmm, you might check and see if LSI has some tools through the controller to access SAS SMART status of drives attached to it; or if it has a pass through function for smartmontools. This is a low priority at the moment. It's just to see if the drives have reported read, write, CRC, or bad sector errors.

I think where you're at with this is that the log is probably corrupt due to the unclean shutdown and that's why it won't mount. So zeroing the log should make it possible, while losing about 30 second worth of whatever was happening before the shutdown.

There's an ambiguity on the status of devid 9 being "deleted" when devid 14 subsequently failed. I think devid 14 needs to be successfully removed first because there's only one copy right now of its data, and possibly some of it is on devid 9. If that succeeds, next is to remove devid 9.

And I'd also check out the replace command to see if that's applicable for either of these rather than using delete. It's a new feature, I haven't used it yet.


Chris Murphy

