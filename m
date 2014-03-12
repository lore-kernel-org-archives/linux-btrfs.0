Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:57262 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaCLTy6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 15:54:58 -0400
Message-ID: <5320BBC8.1090602@libero.it>
Date: Wed, 12 Mar 2014 20:55:52 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Chris Mason <clm@fb.com>, systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E3F10.3000908@libero.it> <20140310234547.GA31229@tango.0pointer.de> <53209868.5090506@fb.com> <5320B18C.9050400@inwind.it> <F34652FB-331F-4BA7-A2D9-35C3DE7B770D@colorremedies.com>
In-Reply-To: <F34652FB-331F-4BA7-A2D9-35C3DE7B770D@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/12/2014 08:31 PM, Chris Murphy wrote:
> 
> On Mar 12, 2014, at 1:12 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> 
[...]
>>
>> I am working to prototype something like that. A "mount.btrfs" command which
>> 1) handles the rollback (i.e. the user make a snapshot which is a rollback; if something goes wrong and the machine reboot before ending the process, during the subvolume mounting phase the rollback replaces the "original" subvolume)
>>
>> 2) handles the automount (i.e. if a subvolume has the right xattr it is automatically mounted in the right place)
>>
>> My idea is that the subvolume are grouped so:
>>
>> @<name>				simple subvolume
>> @<name>.<timestamp>		snapshot of subvolume <name>
>> @<name>.rollback		rollback subvolume
>>
>> If @<name>.rollback exists, then it replace @<name> (something went wrong, the machine rebooted so the rollback have to take place of the original subvolume)
>>
>> For each @<name> subvolume the following xattrs are considered:
>> user.btrfs.automount=1|0	the subvolume has to be automounted
>> user.btrfs.mntpoint=<path>	subvolume mount point
>>
>>
>> So this "mount.btrsf" command should:
>>
>> 1) mount the root btrfs filesystem (subvolid=5) in a temporary directory
>> 2) performing the auto rollback (this behaviour can be controlled by another xattr)
>> 3) mount the subvolume "@" as "root" (like the default one) in the right mount point
>> 4) for each subvolume which has user.btrfs.automount=1, it should be mounted under the path stored in the "user.btrfs.mntpoint" xattr (relative to "@" or absolute)
>> 5) umount the btrfs filesystem mounted at #1, or better move it to a new position in order
>> to allow managing (snapshot) of the different subvolumes.
>>
>> Thoughts ?
> 
> In effect this obviates boot parameter rootflags=subvol= since the
> file system metadata self-describe the subvol to be mounted,
> correct?
Definetely; 
> 
> Your suggestion also sounds like it places snapshots outside of their
> parent subvolume? 
yes, to me snapshot and "parent subvolume" are sibling more than parent/child. This simplify the rollback scenario. For example using the convention above we can rollback all the subvolumes mounting all the snapshots where the timestamp is less than the desired value.

> If so it mitigates a possible security concern if
> the snapshot contains (old) binaries with vulnerabilities. I asked
> about how to go about assessing this on the Fedora security list: 
> https://lists.fedoraproject.org/pipermail/security/2014-February/001748.html
>
> There aren't many replies but the consensus is that it's a legitimate
> concern, so either the snapshots shouldn't be persistently available
> (which is typical with e.g. snapper, and also
> yum-plugin-fs-snapshot), and/or when the subvolume containing
> snapshots is mounted, it's done with either mount option noexec or
> nosuid (no consensus on which one, although Gnome Shell uses nosuid
> by default when automounting removable media). 

Interesting observation
> 
> 
> Chris Murphy
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
