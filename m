Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([212.48.14.170]:50190 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754245AbdIFQnm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 12:43:42 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
 <20170904180856.GG31874@twin.jikos.cz>
 <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
 <a82d6478-9af3-6876-6b29-1b9c4d73b291@libero.it>
 <f5b527c8-e81c-5052-a963-11797d0c7dd7@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <50438174-ffce-031c-1148-f2e61bf35f68@inwind.it>
Date: Wed, 6 Sep 2017 18:43:37 +0200
MIME-Version: 1.0
In-Reply-To: <f5b527c8-e81c-5052-a963-11797d0c7dd7@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/06/2017 01:31 PM, Austin S. Hemmelgarn wrote:
> On 2017-09-05 15:05, Goffredo Baroncelli wrote:
>> On 09/05/2017 10:19 AM, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年09月05日 02:08, David Sterba wrote:
>>>> On Mon, Sep 04, 2017 at 03:41:05PM +0900, Qu Wenruo wrote:
>>>>> mkfs.btrfs --rootdir provides user a method to generate btrfs with
>>>>> pre-written content while without the need of root privilege.
>>>>>
>>>>> However the code is quite old and doesn't get much review or test.
>>>>> This makes some strange behavior, from customized chunk allocation
>>>>> (which uses the reserved 0~1M device space) to lack of special file
>>>>> handler (Fixed in previous 2 patches).
>>>>
>>>> The cleanup in this area is most welcome. The patches look good after a
>>>> quick look, I'll do another review round.
>>>
>>> To save you some time, I found that my rework can't create new image which old --rootdir can do. So it's still not completely the same behavior.
>>> I can fix it by creating a large sparse file first and then truncate it using current method easily.
>>>
>>> But this really concerns me, do we need to shrink the fs?
>>
>> I still fatigue to understand in what "mkfs.btrfs --rootdir" would be better than a "simple tar....";
>>
>> in the first case I have to do
>> a1) mkfs.btrfs --root-dir....  (create the archive)
>> a2) dd  (copy and truncate the image and store it in the archive)
>> a3) dd  (take the archived image, and restore it)
>> a4) btrfs fi resize (expand the image)
> The primary use case for this is to generate installation images.  Using this method removes the need for tar in the installation environment, and if you defer step a4 until the first boot of the system, it also removes the need to have btrfs-progs in the installation environment. Taken together, that's a pretty significant space savings.

Sorry but I don't understand. If you reach the step a3; you have:
- the final disk, and an environment fully working. So I am still inclined to think that using "mkfs.btrfs --root-dir" is more complicated in *this case*.
> 
> It's also somewhat useful for creating minimalistic seed device images, which have a couple of interesting uses, namely:
> 
> * Base system images for 'factory reset'.  The general principal is simple, your base system is a seed device, plus a storage device associated with it.  When you want to do a factory reset, you wipe the storage partition, and recreate an empty one associated with the seed image.  This usage pretty much requires a minimally sized filesystem, as anything more wastes space that would be otherwise usable by the end user.
> 
> * Seed-device based install images.  The general concept for this has been tossed around a couple of times before.  You start with a minimal seed device, boot to a live system using that and a temporary in-memory device for root, set up the persistent storage, re-balance everything to persistent storage, then remove the seed device and in-memory device so the user can keep using the system without needing to reboot.  This also needs a minimalistic image, for the same reason any install disc needs to have a minimal base image.

For the above cases I agree that this could be useful to have "--rootdir"
> 
> Note that without resize being able to shrink chunks (and ideally completely shrink them so there is no slack space in the FS), you have to use a hex editor to get a truly minimalistic filesystem image.
>>
>> in the second case I have to
>> b1) tar cf ... (create the image an store it in the archive, this is a1+a2)
>> b2) mkfs,btrfs (create the filesystem with the final size)
>> b3) tar xf ... (take the archived image and restore it)
>>
>>
>> However the code is already written (and it seems simple enough), so a possible compromise could be to have the "shrinking" only if another option is passed; eg.
>>
>> mkfs.btrfs --root ...                --> populate the filesystem
>> mkfs.btrfs --shrink --root           --> populate and shrink the filesystem
>>
>> however I find this useful only if it is possible to creating the filesystem in a file; ie.
>>
>> mkfs.btrfs --shrink --root <path-to-source-fs> <file-to-be-created>
>>
>> where <file-to-be-created> doesn't have to exists before mkfs.btrfs, and after
>> a) <file-to-be-created> contains the image
>> b) <file-to-be-created> is the smallest possible size.
>>
>> Definitely I don't like the truncate done by the operator by hand after the mkfs.btrfs (current behavior).
> FWIW, the current release behavior doesn't require the truncate, and properly generates the file for the filesystem.  
If you don't do truncate, you have the fully partition... Or there is something that I miss ?

[...]
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
