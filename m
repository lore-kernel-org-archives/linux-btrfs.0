Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53107 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755390AbaCJUxf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 16:53:35 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <531E1EBA.1090404@fb.com>
Date: Mon, 10 Mar 2014 14:53:32 -0600
Cc: Lennart Poettering <lennart@poettering.net>, <kreijack@inwind.it>,
        <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <1A252834-430D-482F-96C7-761A85D2DA74@colorremedies.com>
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E1EBA.1090404@fb.com>
To: Chris Mason <clm@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 10, 2014, at 2:21 PM, Chris Mason <clm@fb.com> wrote:

> On 03/10/2014 04:02 PM, Lennart Poettering wrote:
>> On Mon, 10.03.14 19:34, Goffredo Baroncelli (kreijack@libero.it) wrote:
>> 
>> Heya,
>> 
>>> Instead of relying on the subvolume UUID, why not relying to the subvolume name: it would be more simple and flexible to manage them.
>>> 
>>> For example supposing to use '@' as prefix for a subvolume name:
>>> 
>>> @ 	-> root filesystem
>>> @etc	-> etc
>>> @home 	-> home
>>> [...]
>> 
>> Well, the name is property of the admin really. There needs to be a way
>> how the admin can label his subvolumes, with a potentially localized
>> name. This makes it unsuitable for our purpose, we cannot just take
>> possession of this and leave the admin with nothing.
>> 
>> On GPT there are also gpt partition labels and partition types. The
>> former are property of the admin, he can place there whatever he wants,
>> in whatever language he chooses... The latter however is how we make
>> sense of it on a semantical level.
>> 
>>> Or in another way we could group the different systems in subdirectories:
>>> 
>>> @home		-> home of all the systems
>>> @srv		-> srv  of all the systems
>>> fedora/@	-> root of a fedora system
>>> fedora/@etc	-> etc of the fedora system
>>> fedora2/@	-> root of a fedora2 system
>>> fedora2/@etc	-> etc of the fedora2 system
>> 
>> I am pretty sure automatic discovery of mount points should not cover
>> the usecase where people install multiple distributions into the same
>> btrfs volume. THe automatic logic should cover the simple cases only,
>> and it sounds way over the top to support installing multiple OSes into
>> the same btrfs... I mean, people can do that, if they want to, they just
>> have to write a proper fstab, which I think is not too much too ask...
> 
> Thinking more about this, using the UUIDs does make it harder for the admin to roll back and forth between snapshots.  This is similar to the multiple install idea, but the goal would be easily jumping back to the old one if an update failed.

Since it's not a given whether a parent or child subvolume is the one being updated, it's ambiguous which one to use/automount if there is inheritance of the proposed subvolumetypeGUID at snapshot time. Inheritance of the proposed GUID at snapshot time sounds untenable.

Failsafe for rootfs is to snapshot, mount it, apply updates to the snapshot in a chroot. That way a failed update means the snapshot can be immediately deleted. And the OS is overall more stable by not having running binaries modified or yanked out from under it. Here, using the current subvolume at reboot is the rollback; changing to the snapshot is the upgrade.

Whereas for home, rebooting to the snapshot is a rollback, which I certainly don't want by default.

I don't see the right way to handle this automatically or by default.

> I'm not against anything that makes us more flexible here, just trying to nail down the use case a little bit more.

Faster mounts, before the fstab would otherwise be read and parsed? OS X has deprecated fstab entirely in favor of autodiscovery/automounting. The /etc/fstab is no longer present (but is honored if created).


Chris Murphy

