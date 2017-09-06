Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([212.48.14.170]:49211 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751212AbdIFSbt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 14:31:49 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
 <20170904180856.GG31874@twin.jikos.cz>
 <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
 <a82d6478-9af3-6876-6b29-1b9c4d73b291@libero.it>
 <f5b527c8-e81c-5052-a963-11797d0c7dd7@gmail.com>
 <50438174-ffce-031c-1148-f2e61bf35f68@inwind.it>
 <8aa1c1e2-e938-f011-7306-8480e1f06c49@gmail.com>
 <66d243a6-e3e0-bccc-1f29-008189fb612d@inwind.it>
 <ad587709-7299-9607-6a21-e96f212eb65a@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <03325479-bb84-2d07-f4dc-e22c81da92d8@inwind.it>
Date: Wed, 6 Sep 2017 20:31:44 +0200
MIME-Version: 1.0
In-Reply-To: <ad587709-7299-9607-6a21-e96f212eb65a@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/06/2017 08:02 PM, Austin S. Hemmelgarn wrote:
> On 2017-09-06 13:48, Goffredo Baroncelli wrote:
>> On 09/06/2017 07:16 PM, Austin S. Hemmelgarn wrote:
[...]
>>>> Sorry but I don't understand. If you reach the step a3; you have:
>>>> - the final disk, and an environment fully working. So I am still inclined to think that using "mkfs.btrfs --root-dir" is more complicated in *this case*.
>>> With the current released code (without these patches), `-r` can be used to generate a filesystem image that has zero free space.  In that case, step a3 does not give you a fully working environment,
>>
>> True, this doesn't *give* you a filly working environment, _but_ you perform the step a3 in a "fully working environment", an you have at hand the target disk..
> You could just as easily be booted into a minimalistic install environment, and if you netbooted that, then it's pretty likely that you want it as small as possible, and not needing tar or btrfs-progs for the actual install will save a lot of space (multiple MB doesn't sound like much, but when you're dealing with a tiny system to begin with, it can be very significant).

Step a3 need to have access to the raw disk image build at step1; this is quite incompatible with a "minimalistic install environment"; and even if you have access it via net, in the same way you can have access to a fully working environment....


[...]

>>>>>>
>>>>>> where <file-to-be-created> doesn't have to exists before mkfs.btrfs, and after
>>>>>> a) <file-to-be-created> contains the image
>>>>>> b) <file-to-be-created> is the smallest possible size.
>>>>>>
>>>>>> Definitely I don't like the truncate done by the operator by hand after the mkfs.btrfs (current behavior).
>>>>> FWIW, the current release behavior doesn't require the truncate, and properly generates the file for the filesystem.
>>>> If you don't do truncate, you have the fully partition... Or there is something that I miss ?
>>> The current release, without these patches, run using a non-existent file and the `-r` option, will produce a filesystem image of the exact size needed to hold everything in the directory passed to `-r`.  It doesn't require truncation unless used on a file that already exists.
>>
>> Of course the truncate is not needed, because you are using a sparse file. But if you use a sparse file..... it is not even needed the shrinking! Because the file will consume the same space on the disk !

> Unless you want to use the file elsewhere.  It's a pretty rare occurrence outside of testing that you generate a filesystem image and use it as-is without transferring it somewhere (usually onto an actual storage device).  Once you're talking about moving it, whether or not the file itself is sparse usually doesn't matter, especially if the file is leaving the local system by some means other than NFS or rsync.

????
If you don't truncate you have the full-image in any case....


> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
