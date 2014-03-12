Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44987 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751101AbaCLTbk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 15:31:40 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5320B18C.9050400@inwind.it>
Date: Wed, 12 Mar 2014 13:31:35 -0600
Cc: Chris Mason <clm@fb.com>, systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <F34652FB-331F-4BA7-A2D9-35C3DE7B770D@colorremedies.com>
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E3F10.3000908@libero.it> <20140310234547.GA31229@tango.0pointer.de> <53209868.5090506@fb.com> <5320B18C.9050400@inwind.it>
To: kreijack@inwind.it
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 12, 2014, at 1:12 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

> On 03/12/2014 06:24 PM, Chris Mason wrote:
>> 
>> 
>> On 03/10/2014 07:45 PM, Lennart Poettering wrote:
>>> On Mon, 10.03.14 23:39, Goffredo Baroncelli (kreijack@libero.it) wrote:
>>> 
>>>>> Well, the name is property of the admin really. There needs to be a way
>>>>> how the admin can label his subvolumes, with a potentially localized
>>>>> name. This makes it unsuitable for our purpose, we cannot just take
>>>>> possession of this and leave the admin with nothing.
>>>> 
>>>> Instead of the name we can use the xattr to store these information.
>>> 
>>> Ah, using xattrs for this is indeed an option. That way we should be able
>>> attach any kind of information we like to a subvolume.
>>> 
>>> Hmm, I figure though that there is no way currently to read xattrs off a
>>> subvolume without first mounting them individually? Having to mount all
>>> subvolumes before we can make sense of them and mount them to the right
>>> place certainly sounds less than ideal...
>> 
>> Ok, are we hoping to pull the xattrs off the disk before mounting
>> anything? Or can we do a mount in a side directory first to scan for
>> subvols?
>> 
>> I like the idea of something like this:
>> 
>> mount device on /search_for_fstab cd
>> /search_for_fstab/<some_magic_directory_name_option_in_systemd>
>> 
>> read xattrs on directories it finds to see where they should be
>> mounted in the FS. xattrs may include mount options and special
>> flags.
> 
> I am working to prototype something like that. A "mount.btrfs" command which
> 1) handles the rollback (i.e. the user make a snapshot which is a rollback; if something goes wrong and the machine reboot before ending the process, during the subvolume mounting phase the rollback replaces the "original" subvolume)
> 
> 2) handles the automount (i.e. if a subvolume has the right xattr it is automatically mounted in the right place)
> 
> My idea is that the subvolume are grouped so:
> 
> @<name>				simple subvolume
> @<name>.<timestamp>		snapshot of subvolume <name>
> @<name>.rollback		rollback subvolume
> 
> If @<name>.rollback exists, then it replace @<name> (something went wrong, the machine rebooted so the rollback have to take place of the original subvolume)
> 
> For each @<name> subvolume the following xattrs are considered:
> user.btrfs.automount=1|0	the subvolume has to be automounted
> user.btrfs.mntpoint=<path>	subvolume mount point
> 
> 
> So this "mount.btrsf" command should:
> 
> 1) mount the root btrfs filesystem (subvolid=5) in a temporary directory
> 2) performing the auto rollback (this behaviour can be controlled by another xattr)
> 3) mount the subvolume "@" as "root" (like the default one) in the right mount point
> 4) for each subvolume which has user.btrfs.automount=1, it should be mounted under the path stored in the "user.btrfs.mntpoint" xattr (relative to "@" or absolute)
> 5) umount the btrfs filesystem mounted at #1, or better move it to a new position in order
> to allow managing (snapshot) of the different subvolumes.
> 
> Thoughts ?

In effect this obviates boot parameter rootflags=subvol= since the file system metadata self-describe the subvol to be mounted, correct?

Your suggestion also sounds like it places snapshots outside of their parent subvolume? If so it mitigates a possible security concern if the snapshot contains (old) binaries with vulnerabilities. I asked about how to go about assessing this on the Fedora security list:
https://lists.fedoraproject.org/pipermail/security/2014-February/001748.html

There aren't many replies but the consensus is that it's a legitimate concern, so either the snapshots shouldn't be persistently available (which is typical with e.g. snapper, and also yum-plugin-fs-snapshot), and/or when the subvolume containing snapshots is mounted, it's done with either mount option noexec or nosuid (no consensus on which one, although Gnome Shell uses nosuid by default when automounting removable media).



Chris Murphy

