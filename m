Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34697 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753196AbdA2CLI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 21:11:08 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so68133998wmi.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 18:11:07 -0800 (PST)
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: Re: btrfs recovery
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Hugo Mills <hugo@carfax.org.uk>
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
 <3255da6a-c4a6-c464-7bc7-56fcff281937@googlemail.com>
 <42184069-91dd-9e32-5b41-f13f95960e86@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <dab6c1c7-ebfc-5578-d9f4-ae3001b9efbf@googlemail.com>
Date: Sun, 29 Jan 2017 03:02:14 +0100
MIME-Version: 1.0
In-Reply-To: <42184069-91dd-9e32-5b41-f13f95960e86@mendix.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 28.01.2017 um 23:27 schrieb Hans van Kranenburg:
> On 01/28/2017 10:04 PM, Oliver Freyermuth wrote:
>> Am 26.01.2017 um 12:01 schrieb Oliver Freyermuth:
>>> Am 26.01.2017 um 11:00 schrieb Hugo Mills:
>>>>    We can probably talk you through fixing this by hand with a decent
>>>> hex editor. I've done it before...
>>>>
>>> That would be nice! Is it fine via the mailing list? 
>>> Potentially, the instructions could be helpful for future reference, and "real" IRC is not accessible from my current location. 
>>>
>>> Do you have suggestions for a decent hexeditor for this job? Until now, I have been mainly using emacs, 
>>> classic hexedit (http://rigaux.org/hexedit.html), or okteta (beware, it's graphical!), but of course these were made for a few MiB of files and are not so well suited for a block device. 
>>>
>>> The first thing to do would then probably just be to jump to the offset where 0xd89500014da12000 is written (can I get that via inspect-internal, or do I have to search for it?), fix that to read 
>>> 0x00a800014da12000
>>> (if I understood correctly) and then probably adapt a checksum? 
>>>
>> My external backup via btrfs-restore is now done successfully, so I am ready for anything you throw at me. 
>> Since I was able to pull all data, though, it would mainly be something educational (for me, and likely other list readers). 
>> If you think that this manual procedure is not worth it, I can also just scratch and recreate the FS. 
> 
> OK, let's do it. I also want to practice a bit with stuff like this, so
> this is a nice example.
> 
> See if you can dump the chunk tree (tree 3) with btrfs inspect-internal
> dump-tree -t 3 /dev/xxx
> 
Yes, I can! :-)

> You should get a list of objects like this one:
> 
> item 88 key (FIRST_CHUNK_TREE CHUNK_ITEM 1200384638976) itemoff 9067
> itemsize 80
>   chunk length 1073741824 owner 2 stripe_len 65536
>   type DATA num_stripes 1
>     stripe 0 devid 1 offset 729108447232
>     dev uuid: edae9198-4ea9-4553-9992-af8e27aa6578
> 
> Find the one that contains 35028992
>
> So, where it says 1200384638976 and length 1073741824 in the example
> above, which is the btrfs virtual address space from 1200384638976 to
> 1200384638976 + 1GiB, you need to find the one where 35028992 is between
> the start and start+length.
> 
I found:
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 29360128) itemoff 15993 itemsize 112
                length 1073741824 owner 2 stripe_len 65536 type METADATA|DUP
                io_align 65536 io_width 65536 sector_size 4096
                num_stripes 2 sub_stripes 0
                        stripe 0 devid 1 offset 37748736
                        dev_uuid 76acfc80-aa73-4a21-890b-34d1d2259728
                        stripe 1 devid 1 offset 1111490560
                        dev_uuid 76acfc80-aa73-4a21-890b-34d1d2259728

So I have Metadata DUP (at least I remembered that correctly). 
Now, for the calculation:
37748736+(35028992-29360128)   =   43417600
1111490560+(35028992-29360128) = 1117159424

> Then, look at the stripe line. If you have DUP metadata, it will be a
> type METADATA (instead of DATA in the example above) and it will list
> two stripe lines, which point at the two physical locations in the
> underlying block device.
> 
> The place where your 16kiB metadata block is stored is at physical start
> of stripe + (35028992 - start of virtual address block).
> 
> Then, dump one of the two mirrored 16kiB from disk with something like
> `dd if=/dev/sdb1 bs=1 skip=<physical location> count=16384 > foo`
And the dd'ing:
dd if=/dev/sdb1 bs=1 skip=43417600 count=16384 > mblock_first
dd if=/dev/sdb1 bs=1 skip=1117159424 count=16384 > mblock_second
Just as a cross-check, as expected, the md5sum of both files is the same, so they are identical. 

> 
> File foo of 16kiB size now contains the data that you dumped in the
> pastebin before.
> 
> Using hexedit on this can be a quite confusing experience because of the
> reordering of bytes in the raw data. When you expect to find
> 0xd89500014da12000 somewhere, it probably doesn't show up as d8 95 00 01
> 4d a1 20 00, but in a different order.
> 
Indeed, that's confusing, luckily I'm used to this a bit since I did some close-to-hardware work. 
In the dump, starting at offset 0x1FB8, I get:
00 20 A1 4D  01 00 95 D8
so the expected bytes in reverse. 
So my next step would likely be to change that to:
00 20 A1 4D  01 00 A8 00
and then somehow redo the CRC - correct so far? 

And my very last step would be: 
dd if=mblock_first of=/dev/sdb1 bs=1 skip=43417600 count=16384
dd if=mblock_first of=/dev/sdb1 bs=1 skip=1117159424 count=16384
(of which the "count" is then not really needed, but better safe than sorry). 

> If you end up here, and if you can find the values in the hexdump
> already, please put the 16kiB file somewhere online (or pipe it through
> base64 and pastebin it), so we can help a bit more efficiently.
I've put it online here (ownCloud instance of our University):
https://uni-bonn.sciebo.de/index.php/s/3Vdr7nmmfqPtHot/download
and alternatively as base64 in pastebin:
http://pastebin.com/K1CzCxqi

> After getting the bytelevel stuff right again, the block needs a new
> checksum, and then you have to carefully dd it back in both of the
> places which are listed in the stripe lines.
> 
> If everything goes right... bam! Mount again and happy btrfsing again.
> 

Thanks for all up to here! 
	Oliver
