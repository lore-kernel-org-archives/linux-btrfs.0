Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35680 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753307AbdIFLbU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 07:31:20 -0400
Received: by mail-io0-f176.google.com with SMTP id i14so4142945ioe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Sep 2017 04:31:19 -0700 (PDT)
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
To: kreijack@inwind.it, Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
 <20170904180856.GG31874@twin.jikos.cz>
 <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
 <a82d6478-9af3-6876-6b29-1b9c4d73b291@libero.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f5b527c8-e81c-5052-a963-11797d0c7dd7@gmail.com>
Date: Wed, 6 Sep 2017 07:31:16 -0400
MIME-Version: 1.0
In-Reply-To: <a82d6478-9af3-6876-6b29-1b9c4d73b291@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-05 15:05, Goffredo Baroncelli wrote:
> On 09/05/2017 10:19 AM, Qu Wenruo wrote:
>>
>>
>> On 2017年09月05日 02:08, David Sterba wrote:
>>> On Mon, Sep 04, 2017 at 03:41:05PM +0900, Qu Wenruo wrote:
>>>> mkfs.btrfs --rootdir provides user a method to generate btrfs with
>>>> pre-written content while without the need of root privilege.
>>>>
>>>> However the code is quite old and doesn't get much review or test.
>>>> This makes some strange behavior, from customized chunk allocation
>>>> (which uses the reserved 0~1M device space) to lack of special file
>>>> handler (Fixed in previous 2 patches).
>>>
>>> The cleanup in this area is most welcome. The patches look good after a
>>> quick look, I'll do another review round.
>>
>> To save you some time, I found that my rework can't create new image which old --rootdir can do. So it's still not completely the same behavior.
>> I can fix it by creating a large sparse file first and then truncate it using current method easily.
>>
>> But this really concerns me, do we need to shrink the fs?
> 
> I still fatigue to understand in what "mkfs.btrfs --rootdir" would be better than a "simple tar....";
> 
> in the first case I have to do
> a1) mkfs.btrfs --root-dir....  (create the archive)
> a2) dd  (copy and truncate the image and store it in the archive)
> a3) dd  (take the archived image, and restore it)
> a4) btrfs fi resize (expand the image)
The primary use case for this is to generate installation images.  Using 
this method removes the need for tar in the installation environment, 
and if you defer step a4 until the first boot of the system, it also 
removes the need to have btrfs-progs in the installation environment. 
Taken together, that's a pretty significant space savings.

It's also somewhat useful for creating minimalistic seed device images, 
which have a couple of interesting uses, namely:

* Base system images for 'factory reset'.  The general principal is 
simple, your base system is a seed device, plus a storage device 
associated with it.  When you want to do a factory reset, you wipe the 
storage partition, and recreate an empty one associated with the seed 
image.  This usage pretty much requires a minimally sized filesystem, as 
anything more wastes space that would be otherwise usable by the end user.

* Seed-device based install images.  The general concept for this has 
been tossed around a couple of times before.  You start with a minimal 
seed device, boot to a live system using that and a temporary in-memory 
device for root, set up the persistent storage, re-balance everything to 
persistent storage, then remove the seed device and in-memory device so 
the user can keep using the system without needing to reboot.  This also 
needs a minimalistic image, for the same reason any install disc needs 
to have a minimal base image.

Note that without resize being able to shrink chunks (and ideally 
completely shrink them so there is no slack space in the FS), you have 
to use a hex editor to get a truly minimalistic filesystem image.
> 
> in the second case I have to
> b1) tar cf ... (create the image an store it in the archive, this is a1+a2)
> b2) mkfs,btrfs (create the filesystem with the final size)
> b3) tar xf ... (take the archived image and restore it)
> 
> 
> However the code is already written (and it seems simple enough), so a possible compromise could be to have the "shrinking" only if another option is passed; eg.
> 
> mkfs.btrfs --root ...                --> populate the filesystem
> mkfs.btrfs --shrink --root           --> populate and shrink the filesystem
> 
> however I find this useful only if it is possible to creating the filesystem in a file; ie.
> 
> mkfs.btrfs --shrink --root <path-to-source-fs> <file-to-be-created>
> 
> where <file-to-be-created> doesn't have to exists before mkfs.btrfs, and after
> a) <file-to-be-created> contains the image
> b) <file-to-be-created> is the smallest possible size.
> 
> Definitely I don't like the truncate done by the operator by hand after the mkfs.btrfs (current behavior).
FWIW, the current release behavior doesn't require the truncate, and 
properly generates the file for the filesystem.  It also does some odd 
things with chunk placement (including putting data in the 0-1M range 
which is supposed to be reserved), and that odd behavior is primarily 
what prompted this patch set.
> 
> BTW I compiled successfully the patches, and these seems to work.
> 
> PS: I tried to cross-compile mkfs.btrfs ton arm, but mkfs.btrfs was unable to work:
> 
> $ uname -a
> Linux bananapi 4.4.66-bananian #2 SMP Sat May 6 19:26:50 UTC 2017 armv7l GNU/Linux
> $ sudo ./mkfs.btrfs /dev/loop0
> btrfs-progs v4.12.1-5-g3c9451cd
> See http://btrfs.wiki.kernel.org for more information.
> 
> ERROR: superblock magic doesn't match
> Performing full device TRIM /dev/loop0 (10.00GiB) ...
> ERROR: open ctree failed
> 
> However this problem exists even with a plain v4.12.1. The first error seems to suggest that there is some endian-ness issue
> 
> BR
> G.Baroncelli
> 
>>
>> I had a discussion with Austin about this, thread named "[btrfs-progs] Bug in mkfs.btrfs -r".
>> The only equivalent I found is "mkfs.ext4 -d", which can only create new file if size is given and will not shrink fs.
>> (Genext2fs shrinks the fs, but is no longer in e2fsprogs)
>>
>> If we follow that behavior, the 3rd and 5th patches are not needed, which I'm pretty happy with.
>>
>> Functionally, both behavior can be implemented with current method, but I hope to make sure which is the designed behavior so I can stick to it.
>>
>> I hope you could make the final decision on this so I can update the patchset.
