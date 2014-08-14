Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33669 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753829AbaHNSkz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 14:40:55 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:62634 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XHzxG-003OfW-Bu
	for linux-btrfs@vger.kernel.org; Thu, 14 Aug 2014 12:40:54 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Large files, nodatacow and fragmentation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
Date: Thu, 14 Aug 2014 12:40:53 -0600
Message-Id: <08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com> <20140812011401.568c16e6@natsu> <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com> <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com> <9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com> <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 14, 2014, at 8:30 AM, G. Richard Bellamy <rbellamy@pteradigm.com> wrote:

> This is a p2v target, if that matters. Workload has been minimal since
> virtualizing because I have yet to get usable performance with this
> configuration. The filesystem in the guest is Win7 NTFS. I have seen
> massive thrashing of the underlying volume during VSS operations in
> the guest, if that signifies.

Does the VM have enough memory? Is this swap activity? You can't have a VM depend on swap.


> 
>> 
>> It might be that your workload is best suited for a preallocated raw file that inherits +C, or even possibly an LV.
> 
> I'm close to that decision. As I mentioned, I much prefer the btrfs
> subvolume story over lvm, so moving to raw is probably more desirable
> than that... however, then I run into my lack of understanding of the
> difference between qcow2 and raw with respect to recoverability, e.g.
> does raw have the same ACID characteristics as a qcow2 image, or is
> atomicity a completely separate concern from the format?

NTFS isn't atomic unless you're using transactional NTFS. If your use case requires transactional NTFS I'd think you need to give it an LV, or even better a physical drive or partition of its own, only because adding layers in between transactional NTFS and the physical media seems to me like asking for increasingly non-deterministic results. For sure it increases the test matrix, and if atomic writes is the goal, you have to be willing to sabotage it when testing to know if you're going to get the outcome you expect. Unless someone else has done this exact same setup…

I can't say whether, or to what degree, the layers make this pathological. But transactional NTFS + libvirt bus + libvirt cache policy + qcow2 + Btrfs just seems like a lot of layers. And then the drive itself has a couple: its own write cache should be disabled using hdparm for your described use case, and then also knowing whether it honors write barrier at all or sufficiently.

It sounds like your guest VM might be swapping or indexing, i.e. it's doing random writes, not overwrites, and the guest VM caching policy is causing them to be flushed to disk quickly rather than allowing them to be cached so that the host filesystem can combine those multiple writes into larger sequential writes. That's how you can get many fragments even with xattr +C, and chances are you'd get fragmentation with any file system in that case, if the behavior in the VM is many new random writes rather than overwrites. Transactional NTFS could do that also.

So I'd find out what these writes you're getting are all about, and if you can do something to stop them. If you can't, then you need to look at whether qcow2 on XFS  fragments as badly, and if it doesn't then maybe you've found a bug (some interaction between libvirt, qemu and Btfs?) because I'd expect +C on Btrfs to perform approximately the same as ext4 or XFS in terms of fragmentation. 

So what about Btrfs subvolumes do you prefer for this use case? There might be other ways to mitigate that feature loss when going to XFS; the raid10 can be done with either md/mdadm or LVM; and there may be a fit for bcache here because you actually would get these random writes committed to stable media much faster in that case, and a lot of work has been done to make this more reliable than battery backed write caches on hardware raid.

Also take my results with a grain of salt because I was using libvirt's unsafe caching policy.


> The ability
> for the owning process to recover from corruption or inconsistency is
> a key factor in deciding whether or not to turn COW off in btrfs - if
> your overlying system is capable of such recovery, like a database
> engine or (presumably) virtualization layer, then COW isn't a
> necessary function from the underlying system.

By using +C you've already turned off COW for that file in Btrfs, and you've turned off checksumming. While you still have Btfs snapshots, you also have qcow2 snapshots still.

Anyway, I'd make no assumptions about a particular setup actually recovering consistently and lacking corruption without testing it. Test the VM with "virsh destroy" which is an ungraceful shutdown of the VM. Start it back up and see if your database, or whatever, recovers. A more aggressive test is to kill the VM itself with SIGKILL which is going to clobber anything its cached that hasn't yet been submitted to host controlled storage. And even more aggressive would be a sysrq+b. And finally the power cable - which you can bypass if you're on a UPS.


Chris Murphy