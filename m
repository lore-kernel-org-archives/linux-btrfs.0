Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:41567 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaCLTLR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 15:11:17 -0400
Message-ID: <5320B18C.9050400@inwind.it>
Date: Wed, 12 Mar 2014 20:12:12 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E3F10.3000908@libero.it> <20140310234547.GA31229@tango.0pointer.de> <53209868.5090506@fb.com>
In-Reply-To: <53209868.5090506@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/12/2014 06:24 PM, Chris Mason wrote:
> 
> 
> On 03/10/2014 07:45 PM, Lennart Poettering wrote:
>> On Mon, 10.03.14 23:39, Goffredo Baroncelli (kreijack@libero.it) wrote:
>>
>>>> Well, the name is property of the admin really. There needs to be a way
>>>> how the admin can label his subvolumes, with a potentially localized
>>>> name. This makes it unsuitable for our purpose, we cannot just take
>>>> possession of this and leave the admin with nothing.
>>>
>>> Instead of the name we can use the xattr to store these information.
>>
>> Ah, using xattrs for this is indeed an option. That way we should be able
>> attach any kind of information we like to a subvolume.
>>
>> Hmm, I figure though that there is no way currently to read xattrs off a
>> subvolume without first mounting them individually? Having to mount all
>> subvolumes before we can make sense of them and mount them to the right
>> place certainly sounds less than ideal...
> 
> Ok, are we hoping to pull the xattrs off the disk before mounting
> anything? Or can we do a mount in a side directory first to scan for
> subvols?
> 
> I like the idea of something like this:
> 
> mount device on /search_for_fstab cd
> /search_for_fstab/<some_magic_directory_name_option_in_systemd>
> 
> read xattrs on directories it finds to see where they should be
> mounted in the FS. xattrs may include mount options and special
> flags.

I am working to prototype something like that. A "mount.btrfs" command which
1) handles the rollback (i.e. the user make a snapshot which is a rollback; if something goes wrong and the machine reboot before ending the process, during the subvolume mounting phase the rollback replaces the "original" subvolume)

2) handles the automount (i.e. if a subvolume has the right xattr it is automatically mounted in the right place)

My idea is that the subvolume are grouped so:

@<name>				simple subvolume
@<name>.<timestamp>		snapshot of subvolume <name>
@<name>.rollback		rollback subvolume

If @<name>.rollback exists, then it replace @<name> (something went wrong, the machine rebooted so the rollback have to take place of the original subvolume)

For each @<name> subvolume the following xattrs are considered:
user.btrfs.automount=1|0	the subvolume has to be automounted
user.btrfs.mntpoint=<path>	subvolume mount point


So this "mount.btrsf" command should:

1) mount the root btrfs filesystem (subvolid=5) in a temporary directory
2) performing the auto rollback (this behaviour can be controlled by another xattr)
3) mount the subvolume "@" as "root" (like the default one) in the right mount point
4) for each subvolume which has user.btrfs.automount=1, it should be mounted under the path stored in the "user.btrfs.mntpoint" xattr (relative to "@" or absolute)
5) umount the btrfs filesystem mounted at #1, or better move it to a new position in order
to allow managing (snapshot) of the different subvolumes.

Thoughts ?

BR
G.Baroncelli

> 
> mount the things you find
> 
> umount /search_for_fstab
> 
> I like that it's not actually btrfs specific, since the bind mounts
> will work for any FS. But it naturally fits the /@ namespace that we
> seem to be favoring as a collection point for snapshots and
> subvolumes. 
> -chris
> 
> 
> 
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
