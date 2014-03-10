Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42835 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbaCJUSK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 16:18:10 -0400
Message-ID: <531E1EBA.1090404@fb.com>
Date: Mon, 10 Mar 2014 16:21:14 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, <kreijack@inwind.it>
CC: <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de>
In-Reply-To: <20140310200228.GA18268@tango.0pointer.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2014 04:02 PM, Lennart Poettering wrote:
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
>
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

Thinking more about this, using the UUIDs does make it harder for the 
admin to roll back and forth between snapshots.  This is similar to the 
multiple install idea, but the goal would be easily jumping back to the 
old one if an update failed.

I'm not against anything that makes us more flexible here, just trying 
to nail down the use case a little bit more.

-chris

