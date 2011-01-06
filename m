From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 10:52:36 +0000
Message-ID: <4D259EF4.504@bobich.net>
References: <4D258D6A.9010903@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D258D6A.9010903@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski wrote:
>> I have been thinking a lot about de-duplication for a backup application
>> I am writing. I wrote a little script to figure out how much it would
>> save me. For my laptop home directory, about 100 GiB of data, it was a
>> couple of percent, depending a bit on the size of the chunks. With 4 KiB
>> chunks, I would save about two gigabytes. (That's assuming no MD5 hash
>> collisions.) I don't have VM images, but I do have a fair bit of saved
>> e-mail. So, for backups, I concluded it was worth it to provide an
>> option to do this. I have no opinion on whether it is worthwhile to do
>> in btrfs.
> 
> Online deduplication is very useful for backups of big, multi-gigabyte 
> files which change constantly.
> Some mail servers store files this way; some MUA store the files like 
> this; databases are also common to pack everything in big files which 
> tend to change here and there almost all the time.
> 
> Multi-gigabyte files which only have few megabytes changed can't be 
> hardlinked; simple maths shows that even compressing multiple files 
> which have few differences will lead to greater space usage than a few 
> megabytes extra in each (because everything else is deduplicated).
> 
> And I don't even want to think about IO needed to offline dedup a 
> multi-terabyte storage (1 TB disks and bigger are becoming standard 
> nowadays) i.e. daily, especially when the storage is already heavily 
> used in IO terms.
> 
> 
> Now, one popular tool which can deal with small changes in files is 
> rsync. It can be used to copy files over the network - so that if you 
> want to copy/update a multi-gigabyte file which only has a few changes, 
> rsync would need to transfer just a few megabytes.
> 
> On disk however, rsync creates a "temporary copy" of the original file, 
> where it packs unchanged contents together with any changes made. For 
> example, while it copies/updates a file, we will have:
> 
> original_file.bin
> .temporary_random_name
> 
> Later, original_file.bin would be removed, and .temporary_random_name 
> would be renamed to original_file.bin. Here goes away any deduplication 
> we had so far, we have to start the IO over again.

You can tell rsync to either modify the file in place (--inplace) or to 
put the temp file somewhere else (--temp-dir=DIR).

Gordan
