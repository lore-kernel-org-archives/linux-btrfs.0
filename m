Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:42350 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaCJWiZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 18:38:25 -0400
Message-ID: <531E3F10.3000908@libero.it>
Date: Mon, 10 Mar 2014 23:39:12 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de>	<531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de>
In-Reply-To: <20140310200228.GA18268@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2014 09:02 PM, Lennart Poettering wrote:
> On Mon, 10.03.14 19:34, Goffredo Baroncelli (kreijack@libero.it) wrote:
> 
> Heya,
> 
>> Instead of relying on the subvolume UUID, why not relying to the subvolume name: it would be more simple and flexible to manage them.
>>
>> For example supposing to use '@' as prefix for a subvolume name:
>>
>> @ 	-> root filesystem
>> @etc	-> etc
>> @home 	-> home
>> [...]
> 
> Well, the name is property of the admin really. There needs to be a way
> how the admin can label his subvolumes, with a potentially localized
> name. This makes it unsuitable for our purpose, we cannot just take
> possession of this and leave the admin with nothing.

Instead of the name we can use the xattr to store these information.


> On GPT there are also gpt partition labels and partition types. The
> former are property of the admin, he can place there whatever he wants,
> in whatever language he chooses... The latter however is how we make
> sense of it on a semantical level.
> 
>> Or in another way we could group the different systems in subdirectories:
>>
>> @home		-> home of all the systems
>> @srv		-> srv  of all the systems
>> fedora/@	-> root of a fedora system
>> fedora/@etc	-> etc of the fedora system
>> fedora2/@	-> root of a fedora2 system
>> fedora2/@etc	-> etc of the fedora2 system
> 
> I am pretty sure automatic discovery of mount points should not cover
> the usecase where people install multiple distributions into the same
> btrfs volume. THe automatic logic should cover the simple cases only,
> and it sounds way over the top to support installing multiple OSes into
> the same btrfs... I mean, people can do that, if they want to, they just
> have to write a proper fstab, which I think is not too much too ask...

In your specification, you referred the use case of "container" (via nspawn / libvrt-lxc). which have to boot "a disk image". Why you don't mind to use a container on a btrfs snapshot ? I think that it will be reasonable to have different containers on a snapshots of the same filesystem-tree.


> 
> Lennart
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
