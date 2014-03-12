Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45202 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755991AbaCLRVy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 13:21:54 -0400
Message-ID: <53209868.5090506@fb.com>
Date: Wed, 12 Mar 2014 13:24:56 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, <kreijack@inwind.it>
CC: <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E3F10.3000908@libero.it> <20140310234547.GA31229@tango.0pointer.de>
In-Reply-To: <20140310234547.GA31229@tango.0pointer.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/10/2014 07:45 PM, Lennart Poettering wrote:
> On Mon, 10.03.14 23:39, Goffredo Baroncelli (kreijack@libero.it) wrote:
>
>>> Well, the name is property of the admin really. There needs to be a way
>>> how the admin can label his subvolumes, with a potentially localized
>>> name. This makes it unsuitable for our purpose, we cannot just take
>>> possession of this and leave the admin with nothing.
>>
>> Instead of the name we can use the xattr to store these information.
>
> Ah, using xattrs for this is indeed an option. That way we should be able
> attach any kind of information we like to a subvolume.
>
> Hmm, I figure though that there is no way currently to read xattrs off a
> subvolume without first mounting them individually? Having to mount all
> subvolumes before we can make sense of them and mount them to the right
> place certainly sounds less than ideal...

Ok, are we hoping to pull the xattrs off the disk before mounting 
anything?  Or can we do a mount in a side directory first to scan for 
subvols?

I like the idea of something like this:

mount device on /search_for_fstab
cd /search_for_fstab/<some_magic_directory_name_option_in_systemd>

read xattrs on directories it finds to see where they should be mounted 
in the FS.  xattrs may include mount options and special flags.

mount the things you find

umount /search_for_fstab

I like that it's not actually btrfs specific, since the bind mounts will 
work for any FS.  But it naturally fits the /@ namespace that we seem to 
be favoring as a collection point for snapshots and subvolumes.

-chris




