Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39622 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751276AbaAEUZV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 15:25:21 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52233 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VzuG8-000RBT-UP
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 13:25:21 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C87A41.9030701@jrs-s.net>
Date: Sun, 5 Jan 2014 13:25:19 -0700
Message-Id: <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com>
References: <52C73987.7000106@jrs-s.net>	<52C73D1A.8060805@gmail.com>	<52C7402A.7050605@jrs-s.net> <CAOjFWZ7zC3=4oH6=SBZA+PhZMrSK1KjxoRN6L2vqd=GTBKKTQA@mail.gmail.com> <52C74B00.7080906@jrs-s.net> <03E88FCB-C473-4978-B682-076B90039E0E@colorremedies.com> <52C77903.9060408@jrs-s.net> <241D8699-CA7A-433E-B573-012F44026411@colorremedies.com> <52C87A41.9030701@jrs-s.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 4, 2014, at 2:16 PM, Jim Salter <jim@jrs-s.net> wrote:

> 
> On 01/04/2014 02:18 PM, Chris Murphy wrote:
>> I'm not sure what else you're referring to?(working on boot environment of btrfs)
> 
> Just the string of caveats regarding mounting at boot time - needing to monkeypatch 00_header to avoid the bogus sparse file error

I don't know what "bogus sparse file error" refers to. What version of GRUB? I'm seeing Ubuntu 12.03 precise-updates listing GRUB 1.99 which is rather old.


> (which, worse, tells you to press a key when pressing a key does nothing) followed by this, in my opinion completely unexpected, behavior when missing a disk in a fault-tolerant array, which also requires monkey-patching in fstab and now elsewhere in GRUB to avoid.

and…

> I'm aware it's not intended for production yet.

On the one hand you say you're aware, yet on the other hand you say the missing disk behavior is completely unexpected.

Some parts of Btrfs, in certain contexts, are production ready. But the developmental state of Btrfs places a burden on the user to know more details about that state than he might otherwise be expected to know with more stable/mature file systems.

My opinion is that it's inappropriate for degraded mounts to be made automatic when there's no method of notifying user space of this state change. Gnome-shell via udisks will inform users of a degraded md array. Something equivalent to that is needed before Btrfs should enable a scenario where a user boots a computer in degraded state without being informed as if there's nothing wrong at all. That's demonstrably far worse than "scary" boot failure, during which one copy of data is still likely safe, unlike permitting uninformed degraded rw operation.



> However, it's just on the cusp, with distributions not only including it in their installers but a couple teetering on the fence with declaring it their next default FS (Oracle Unbreakable, OpenSuse, hell even RedHat was flirting with the idea) that it seems to me some extra testing with an eye towards production isn't a bad thing.

Does the Ubuntu 12.03 LTS installer let you create sysroot on a Btrfs raid1 volume?

> That's why I'm here. Not to crap on anybody, but to get involved, hopefully helpfully.

I think you're better off using something more developmental, it necessarily needs to exist in the first place there, before it can trickle down to an LTS release.

> 
>> fs_passno is 1 which doesn't apply to Btrfs.
> Again, that's the distribution's default, so the argument should be with them, not me…

Yes so you'd want to file a bug? That's how you get involved.

> with that said, I'd respectfully argue that fs_passno 1 is correct for any root file system; if the file system itself declines to run an fsck that's up to the filesystem, but it's correct to specify fs_passno 1 if the filesystem is to be mounted as root in the first place.
> 
> I'm open to hearing why that's a bad idea, if you have a specific reason?

It's a minor point, but it shows that fs_passno has become quaint, like grandma's iron cozy. It's not applicable for either XFS or Btrfs. It's arguably inapplicable for ext3/4 but its fsck program has an optimization to skip fully checking the file system if the journal replay succeeds. There is no unattended fsck for either XFS or Btrfs.

On systemd systems, it reads fstab, and if fs_passno is non-zero it checks for the existence of /sbin/fsck.<fs> and if it doesn't exist, then it doesn't run fsck for that entry. This topic was recently brought up and is in the archives.


>> Well actually LVM thinp does have fast snapshots without requiring preallocation, and uses COW.
> 
> LVM's snapshots aren't very useful for me - there's a performance penalty while you have them in place, so they're best used as a transient use-then-immediately-delete feature, for instance for rsync'ing off a database binary. Until recently, there also wasn't a good way to roll back an LV to a snapshot, and even now, that can be pretty problematic.

This describes old LVM snapshots, not LVM thinp snapshots.

> Finally, there's no way to get a partial copy of an LV snapshot out of the snapshot and back into production, so if eg you have virtual machines of significant size, you could be looking at *hours* of file copy operations to restore an individual VM out of a snapshot (if you even have the drive space available for it), as compared to btrfs' cp --reflink=always operation, which allows you to do the same thing instantaneously.

LVM isn't a file system, so limitations compared to Btrfs are expected.

> 
>> I'm not sure what you mean by self-correcting, but if the drive reports a read error md, lvm, and Btrfs raid1+ all will get missing data from mirror/parity reconstruction, and write corrected data back to the bad sector.
> 
> You're assuming that the drive will actually *report* a read error, which is frequently not the case.

This is discussed in significant detail in the linux-raid@ list archives. I'm not aware of data that explicitly concludes or proposes a ratio between ECC error detection with non-correction (resulting in a read error) vs silent data corruption. I've seen quite a few read errors from drives compared to what I think was SDC - but that's not a scientific sample. Polluting a lot of the data is a mismatch between default drive ERC timeouts compared to SCSI block layer timeouts, so when a drive ECC isn't able to produce a result within the SCSI block layer timeout time, we get a link reset. Now we don't know what the drive would have reported, a read error? Or bogus data?


> I have a production ZFS array right now that I need to replace an Intel SSD on - the SSD has thrown > 10K checksum errors in six months. Zero read or write errors. Neither hardware RAID nor mdraid nor LVM would have helped me there.

Of course, that's not their design goal. But I don't think the Btrfs devs are suggesting a design goal is to compensate for spectacular failure of the drive's ECC, because if all drives in your Btrfs volume behaved the way this one SSD you're reporting behaves, you'd inevitably still lose data. Btrfs checksumming isn't a substitute for drive ECC. What you're reporting is a significant ECC fail.


> Since running filesystems that do block-level checksumming, I have become aware that bitrot happens without hardware errors getting thrown FAR more frequently than I would have thought before having the tools to spot it. ZFS, and now btrfs, are the only tools at hand that can actually prevent it.

There are other tools than ZFS and Btrfs, they just aren't open source.

10K checksum errors in six months without a single read error is not bitrot, it's a more significant failure. Bitrot is one kind of silent data corruption, not all SDC is due to bit rot, there are a lot of other sources for data corruption in the storage stack.

Yes it's good we have ZFS and Btrfs for additional protection, but I don't see these file systems as getting manufacturers off the hook with respect to ECC. That needs to get better, they know it needs to get better and that's one of the major reasons why spinning drives have moved to 4K physical sectors. So moving to checksumming file systems isn't the only way to prevent these problems.


Chris Murphy