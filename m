Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:36074 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdIFSCM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 14:02:12 -0400
Received: by mail-it0-f41.google.com with SMTP id y65so1955993itc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Sep 2017 11:02:11 -0700 (PDT)
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
To: kreijack@inwind.it, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
 <20170904180856.GG31874@twin.jikos.cz>
 <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
 <a82d6478-9af3-6876-6b29-1b9c4d73b291@libero.it>
 <f5b527c8-e81c-5052-a963-11797d0c7dd7@gmail.com>
 <50438174-ffce-031c-1148-f2e61bf35f68@inwind.it>
 <8aa1c1e2-e938-f011-7306-8480e1f06c49@gmail.com>
 <66d243a6-e3e0-bccc-1f29-008189fb612d@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ad587709-7299-9607-6a21-e96f212eb65a@gmail.com>
Date: Wed, 6 Sep 2017 14:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <66d243a6-e3e0-bccc-1f29-008189fb612d@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-06 13:48, Goffredo Baroncelli wrote:
> On 09/06/2017 07:16 PM, Austin S. Hemmelgarn wrote:
>> On 2017-09-06 12:43, Goffredo Baroncelli wrote:
>>> On 09/06/2017 01:31 PM, Austin S. Hemmelgarn wrote:
>>>> On 2017-09-05 15:05, Goffredo Baroncelli wrote:
>>>>> On 09/05/2017 10:19 AM, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>> On 2017年09月05日 02:08, David Sterba wrote:
>>>>>>> On Mon, Sep 04, 2017 at 03:41:05PM +0900, Qu Wenruo wrote:
>>>>>>>> mkfs.btrfs --rootdir provides user a method to generate btrfs with
>>>>>>>> pre-written content while without the need of root privilege.
>>>>>>>>
>>>>>>>> However the code is quite old and doesn't get much review or test.
>>>>>>>> This makes some strange behavior, from customized chunk allocation
>>>>>>>> (which uses the reserved 0~1M device space) to lack of special file
>>>>>>>> handler (Fixed in previous 2 patches).
>>>>>>>
>>>>>>> The cleanup in this area is most welcome. The patches look good after a
>>>>>>> quick look, I'll do another review round.
>>>>>>
>>>>>> To save you some time, I found that my rework can't create new image which old --rootdir can do. So it's still not completely the same behavior.
>>>>>> I can fix it by creating a large sparse file first and then truncate it using current method easily.
>>>>>>
>>>>>> But this really concerns me, do we need to shrink the fs?
>>>>>
>>>>> I still fatigue to understand in what "mkfs.btrfs --rootdir" would be better than a "simple tar....";
>>>>>
>>>>> in the first case I have to do
>>>>> a1) mkfs.btrfs --root-dir....  (create the archive)
>>>>> a2) dd  (copy and truncate the image and store it in the archive)
>>>>> a3) dd  (take the archived image, and restore it)
>>>>> a4) btrfs fi resize (expand the image)
>>>> The primary use case for this is to generate installation images.  Using this method removes the need for tar in the installation environment, and if you defer step a4 until the first boot of the system, it also removes the need to have btrfs-progs in the installation environment. Taken together, that's a pretty significant space savings.
>>>
>>> Sorry but I don't understand. If you reach the step a3; you have:
>>> - the final disk, and an environment fully working. So I am still inclined to think that using "mkfs.btrfs --root-dir" is more complicated in *this case*.
>> With the current released code (without these patches), `-r` can be used to generate a filesystem image that has zero free space.  In that case, step a3 does not give you a fully working environment,
> 
> True, this doesn't *give* you a filly working environment, _but_ you perform the step a3 in a "fully working environment", an you have at hand the target disk..
You could just as easily be booted into a minimalistic install 
environment, and if you netbooted that, then it's pretty likely that you 
want it as small as possible, and not needing tar or btrfs-progs for the 
actual install will save a lot of space (multiple MB doesn't sound like 
much, but when you're dealing with a tiny system to begin with, it can 
be very significant).
> 
> What I am saying is that both step a1..a3 and b1..b3 are done in a "fully working environment". The only difference is that you will need a further step a4
> 
>> it gives you a basic environment that can probably be booted to a minimal degree and run just enough to be able to resize the filesystem to take up the whole disk.
>>
>> IOW, the use case I'm referring to here is more akin to that of genext2fs -d than mkfs.ext4 -d, although mkfs.btrfs -r generates a minimally sized FS right now, while neither of the other two do so by default (although I could have sworn that genext2fs could).
>>>>
>>>> It's also somewhat useful for creating minimalistic seed device images, which have a couple of interesting uses, namely:
>>>>
>>>> * Base system images for 'factory reset'.  The general principal is simple, your base system is a seed device, plus a storage device associated with it.  When you want to do a factory reset, you wipe the storage partition, and recreate an empty one associated with the seed image.  This usage pretty much requires a minimally sized filesystem, as anything more wastes space that would be otherwise usable by the end user.
>>>>
>>>> * Seed-device based install images.  The general concept for this has been tossed around a couple of times before.  You start with a minimal seed device, boot to a live system using that and a temporary in-memory device for root, set up the persistent storage, re-balance everything to persistent storage, then remove the seed device and in-memory device so the user can keep using the system without needing to reboot.  This also needs a minimalistic image, for the same reason any install disc needs to have a minimal base image.
>>>
>>> For the above cases I agree that this could be useful to have "--rootdir"
>>>>
>>>> Note that without resize being able to shrink chunks (and ideally completely shrink them so there is no slack space in the FS), you have to use a hex editor to get a truly minimalistic filesystem image.
>>>>>
>>>>> in the second case I have to
>>>>> b1) tar cf ... (create the image an store it in the archive, this is a1+a2)
>>>>> b2) mkfs,btrfs (create the filesystem with the final size)
>>>>> b3) tar xf ... (take the archived image and restore it)
>>>>>
>>>>>
>>>>> However the code is already written (and it seems simple enough), so a possible compromise could be to have the "shrinking" only if another option is passed; eg.
>>>>>
>>>>> mkfs.btrfs --root ...                --> populate the filesystem
>>>>> mkfs.btrfs --shrink --root           --> populate and shrink the filesystem
>>>>>
>>>>> however I find this useful only if it is possible to creating the filesystem in a file; ie.
>>>>>
>>>>> mkfs.btrfs --shrink --root <path-to-source-fs> <file-to-be-created>
>>>>>
>>>>> where <file-to-be-created> doesn't have to exists before mkfs.btrfs, and after
>>>>> a) <file-to-be-created> contains the image
>>>>> b) <file-to-be-created> is the smallest possible size.
>>>>>
>>>>> Definitely I don't like the truncate done by the operator by hand after the mkfs.btrfs (current behavior).
>>>> FWIW, the current release behavior doesn't require the truncate, and properly generates the file for the filesystem.
>>> If you don't do truncate, you have the fully partition... Or there is something that I miss ?
>> The current release, without these patches, run using a non-existent file and the `-r` option, will produce a filesystem image of the exact size needed to hold everything in the directory passed to `-r`.  It doesn't require truncation unless used on a file that already exists.
> 
> Of course the truncate is not needed, because you are using a sparse file. But if you use a sparse file..... it is not even needed the shrinking! Because the file will consume the same space on the disk !
Unless you want to use the file elsewhere.  It's a pretty rare 
occurrence outside of testing that you generate a filesystem image and 
use it as-is without transferring it somewhere (usually onto an actual 
storage device).  Once you're talking about moving it, whether or not 
the file itself is sparse usually doesn't matter, especially if the file 
is leaving the local system by some means other than NFS or rsync.
