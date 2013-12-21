Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54894 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3LUXQ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Dec 2013 18:16:57 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so3971444pbc.6
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Dec 2013 15:16:57 -0800 (PST)
Message-ID: <52B62166.2080407@gmail.com>
Date: Sat, 21 Dec 2013 15:16:54 -0800
From: Chris Kastorff <encryptio@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
References: <52B2BBE1.8090306@gmail.com> <724763DD-956D-4A88-A6DA-E178E246536B@colorremedies.com> <52B38A05.9060407@gmail.com> <A2FBF80C-4BD4-43CD-ACA2-A2125027E701@colorremedies.com>
In-Reply-To: <A2FBF80C-4BD4-43CD-ACA2-A2125027E701@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> - Array is good. All drives are accounted for, btrfs scrub runs cleanly.
>> btrfs fi show shows no missing drives and reasonable allocations.
>> - I start btrfs dev del to remove devid 9. It chugs along with no
>> errors, until:
>> - Another drive in the array (NOT THE ONE I RAN DEV DEL ON) fails, and
>> all reads and writes to it fail, causing the SCSI errors above.
>> - I attempt clean shutdown. It takes too long for because my drive
>> controller card is buzzing loudly and the neighbors are sensitive to
>> noise, so:
>> - I power down the machine uncleanly.
>> - I remove the failed drive, NOT the one I ran dev del on.
>> - I reboot, attempt to mount with various options, all of which cause
>> the kernel to yell at me and the mount command returns failure.
> 
> devid 9 is "device delete" in-progress, and while that's occurring devid 15 fails completely. Is that correct?

Either devid 14 or devid 10 (from memory) dropped out, devid 15 is still working.

> Because previously you reported, in part this:
>        devid   15 size 1.82TB used 1.47TB path /dev/sdd
>        *** Some devices missing
> 
> And this:
> 
> sd 0:2:3:0: [sdd] Unhandled error code

Yeah, those two are from different boots. sdd is the one that dropped out, and after a reboot another (working) drive was renumbered to sdd. Sorry for the confusion.

(Also note that if devid 15 was missing, it would not be reported in btrfs fi show.)

> That why I was confused. It looks like dead/missing device is one devid, and then devid 15 /dev/sdd is also having hardware problems - because all of this was posted at the same time. But I take it they're different boots and the /dev/sdd's are actually two different devids.
> 
> So devid 9 was "deleted" and then devid 14 failed. Right? Lovely when /dev/sdX changes between boots.

It never finished the deletion (was probably about halfway through,
based on previous dev dels), but otherwise yes.

>> From what I understand, at all points there should be at least two
>> copies of every extent during a dev del when all chunks are allocated
>> RAID10 (and they are, according to btrfs fi df ran before on the mounted
>> fs).
>>
>> Because of this, I expect to be able to use the chunks from the (not
>> successfully removed) devid=9, as I have done many many times before due
>> to other btrfs bugs that needed unclean shutdowns during dev del.
> 
> I haven't looked at the code or read anything this specific on the state of the file system during a device delete. But my expectation is that there are 1-2 chunks available for writes. And 2-3 chunks available for reads. Some writes must be only one copy because a chunk hasn't yet been replicated elsewhere, and presumably the device being "deleted" is not subject to writes as the transid also implies. Whereas devid 9 is one set of chunks for reading, those chunks have pre-existing copies elsewhere in the file system so that's two copies. And there's a replication in progress of the soon to be removed chunks. So that's up to three copies.
> 
> Problem is that for sure you've lost some chunks due to the failed/missing device. Normal raid10, it's unambiguous whether we've lost two mirrored sets. With Btrfs that's not clear as chunks are distributed. So it's possible that there are some chunks that don't exist at all for writes, and only 1 for reads. It may be no chunks are in common between devid 9 and the dead one. It may be only a couple of data or metadata chunks are in common.
> 
> 
> 
>>
>> Under the assumption devid=9 is good, if a slightly out of date on
>> transid (which ALL data says is true), I should be able to completely
>> recover all data, because data that was not modified during the deletion
>> resides on devid=9, and data that was modified should be redundantly
>> (RAID10) stored on the remaining drives, and thus should work given this
>> case of a single drive failure.
>>
>> Is this not the case? Does btrfs not maintain redundancy during device
>> removal?
> 
> Good questions. I'm not certain. But the speculation seems reasonable, not accounting for the missing device. That's what makes this different.
> 
> 
> 
>>>> btrfs read error corrected: ino 1 off 87601116364800 (dev /dev/sdf
>>>> sector 62986400)
>>>>
>>>> btrfs read error corrected: ino 1 off 87601116798976 (dev /dev/sdg
>>>> sector 113318256)
>>>
>>> I'm not sure what constitutes a btrfs read error, maybe the device it
>>> originally requested data from didn't have it where it was expected
>>> but was able to find it on these devices. If the drive itself has a
>>> problem reading a sector and ECC can't correct it, it reports the
>>> read error to libata. So kernel messages report this with a line that
>>> starts with the word "exception" and then a line with "cmd" that
>>> shows what command and LBAs where issued to the drive, and then a
>>> "res" line that should contain an error mask with the actual error -
>>> bus error, media error. Very often you don't see these and instead
>>> see link reset messages, which means the drive is hanging doing
>>> something (probably attempting ECC) but then the linux SCSI layer
>>> hits its 30 second time out on the (hanged) queued command and resets
>>> the drive instead of waiting any longer. And that's a problem also
>>> because it prevents bad sectors from being fixed by Btrfs. So they
>>> just get worse to the point where then it can't do anything about the
>>> situation.
>>
>> There was a single drive immediately failing all its writes and reads
>> because that's how the controller card was configured. 
> 
> OK so my next confusion stems from the error corrected messages above. I kinda expect error message to report the device with the error. But this seems to rather be an informational message that a read error was successfully correct, operations are normal. If so, that means /dev/sdf and /dev/sdg are the devices the recovered data came from?

That's what I guessed when I saw it too.

>> Full dmesg after reboot annotated with mount and btrfsck commands as I
>> ran them is at https://encryptio.com/z/btrfs-failure-dmesg.txt ;
> 
> Off topic:
> 
> This:
> [    0.866365] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20130725/psargs-359)
> [    0.866372] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff8807f3ca1460), AE_NOT_FOUND (20130725/psparse-536)
>  
> leads to these two:
> https://bugzilla.redhat.com/show_bug.cgi?id=491588
> 
> http://markmail.org/message/eiodqm526mtejbpj#mid:srmaa4qaqkucz4gf+state:results
> 
> It suggests updating BIOS. Although nothing newer or in combination with 9260-8i…
> 
> 
> Back to topic:
> 
> You have one missing/dead device. And devid 9 which was requested for 'device delete' but are uncertain about its state, whether the in-progress "delete" was halted upon another drive dying.
> 
> The chunks from the missing/dead drive are not automatically replicated. You need to use 'btrfs device delete missing' or you need to use 'btrfs replace' which is a newish command:
> 
> http://lwn.net/Articles/524589/
> 
> And then once that's complete it seems like you should be able to try deleting devid 9 again.
> 
> So where you're at now is you need a way to successfully mount the file system with -o degraded, not ro, so that you can successfully issue those commands, which I wouldn't expect work with an ro file system. But the problem is that you get a open_ctree failed message.
> 
> Next steps:
> 
> 1. btrfs-image -c 9 -t <#cores> (see man page)
> This is optional but one of the devs might want to see this because it should be a more rare case that either normal mount fix ups or additional recovery fix ups can't deal with this problem.

This fails:

deep# ./btrfs-image -c 9 -t 4 /dev/sda btrfsimg
warning, device 14 is missing
warning devid 14 not found already
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
Error going to next leaf -5
create failed (Bad file descriptor)

Adding -w causes it to hang forever (at least 16 hours) after an initial few
minutes of seemingly useful io:

deep# ./btrfs-image -c 9 -t 4 -w /dev/sda btrfsimg
warning, device 14 is missing
warning devid 14 not found already
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
^C

> 2. btrfs-zero-log <dev>

This one gives the most useful (and scariest) error message I've seen so far:

deep# ./btrfs-zero-log /dev/sda
warning, device 14 is missing
warning devid 14 not found already
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
Unable to find block group for 0
btrfs-zero-log: extent-tree.c:288: find_search_start: Assertion `!(1)'
failed.
zsh: abort (core dumped)  ./btrfs-zero-log /dev/sda

> What's the full result from btrfs check <device>?

deep# ./btrfs check /dev/sda
warning, device 14 is missing
warning devid 14 not found already
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
Checking filesystem on /dev/sda
UUID: d5e17c49-d980-4bde-bd96-3c8bc95ea077
checking extents
parent transid verify failed on 87601117159424 wanted 4893969 found 4893913
parent transid verify failed on 87601117159424 wanted 4893969 found 4893913
parent transid verify failed on 87601117163520 wanted 4893969 found 4893913
parent transid verify failed on 87601117163520 wanted 4893969 found 4893913
parent transid verify failed on 87601117638656 wanted 4893969 found 4893913
parent transid verify failed on 87601117638656 wanted 4893969 found 4893913
Ignoring transid failure
parent transid verify failed on 87601117171712 wanted 4893969 found 4893913
parent transid verify failed on 87601117171712 wanted 4893969 found 4893913
parent transid verify failed on 87601117175808 wanted 4893969 found 4893913
parent transid verify failed on 87601117175808 wanted 4893969 found 4893913
parent transid verify failed on 87601117188096 wanted 4893969 found 4893913
parent transid verify failed on 87601117188096 wanted 4893969 found 4893913
parent transid verify failed on 87601116807168 wanted 4893969 found 4893913
parent transid verify failed on 87601116807168 wanted 4893969 found 4893913
Ignoring transid failure
parent transid verify failed on 87601117642752 wanted 4893969 found 4893913
parent transid verify failed on 87601117642752 wanted 4893969 found 4893913
Ignoring transid failure
parent transid verify failed on 87601117650944 wanted 4893969 found 4893913
parent transid verify failed on 87601117650944 wanted 4893969 found 4893913
Ignoring transid failure
Couldn't map the block 5764607523034234880
btrfs: volumes.c:1102: btrfs_num_copies: Assertion `!(!ce)' failed.
zsh: abort (core dumped)  ./btrfs check /dev/sda

> 3. Try to mount again with -o degraded,recovery and report back.

Since btrfs-zero-log (probably) didn't modify anything, the error
message is the same:

btrfs: allowing degraded mounts
btrfs: enabling auto recovery
btrfs: disk space caching is enabled
btrfs: bdev (null) errs: wr 344288, rd 230234, flush 0, corrupt 0, gen 0
btrfs: bdev /dev/sdm1 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
btrfs: bdev /dev/sdg errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Failed to read block groups: -5
btrfs: open_ctree failed

>> The raid card software (an on-boot configuration tool) shows no SMART
>> errors or warnings on any of the remaining drives. Unfortunately I can't
>> get smartctl to actually grab any data through the controller:
> 
> Hmm, you might check and see if LSI has some tools through the controller to access SAS SMART status of drives attached to it; or if it has a pass through function for smartmontools. This is a low priority at the moment. It's just to see if the drives have reported read, write, CRC, or bad sector errors.
> 
> I think where you're at with this is that the log is probably corrupt due to the unclean shutdown and that's why it won't mount. So zeroing the log should make it possible, while losing about 30 second worth of whatever was happening before the shutdown.
> 
> There's an ambiguity on the status of devid 9 being "deleted" when devid 14 subsequently failed. I think devid 14 needs to be successfully removed first because there's only one copy right now of its data, and possibly some of it is on devid 9. If that succeeds, next is to remove devid 9.
> 
> And I'd also check out the replace command to see if that's applicable for either of these rather than using delete. It's a new feature, I haven't used it yet.

If replace works with "missing", that seems like the right way to go.

btrfs-zero-log's "Unable to find block group for 0" combined with the
earlier kernel message on mount attempts "btrfs: failed to read the
system array on sdc" and btrfsck's "Couldn't map the block %ld" tells me
the (first) underlying problem is that the block group tree(?) in the
system allocated data is screwed up.

I have no idea where to go from here, aside from grabbing a compiler and
having at the disk structures myself.
