Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35-wd.italiaonline.it ([212.48.13.169]:44500 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751774AbdIETF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Sep 2017 15:05:29 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
 <20170904180856.GG31874@twin.jikos.cz>
 <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <a82d6478-9af3-6876-6b29-1b9c4d73b291@libero.it>
Date: Tue, 5 Sep 2017 21:05:24 +0200
MIME-Version: 1.0
In-Reply-To: <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2017 10:19 AM, Qu Wenruo wrote:
> 
> 
> On 2017年09月05日 02:08, David Sterba wrote:
>> On Mon, Sep 04, 2017 at 03:41:05PM +0900, Qu Wenruo wrote:
>>> mkfs.btrfs --rootdir provides user a method to generate btrfs with
>>> pre-written content while without the need of root privilege.
>>>
>>> However the code is quite old and doesn't get much review or test.
>>> This makes some strange behavior, from customized chunk allocation
>>> (which uses the reserved 0~1M device space) to lack of special file
>>> handler (Fixed in previous 2 patches).
>>
>> The cleanup in this area is most welcome. The patches look good after a
>> quick look, I'll do another review round.
> 
> To save you some time, I found that my rework can't create new image which old --rootdir can do. So it's still not completely the same behavior.
> I can fix it by creating a large sparse file first and then truncate it using current method easily.
> 
> But this really concerns me, do we need to shrink the fs?

I still fatigue to understand in what "mkfs.btrfs --rootdir" would be better than a "simple tar...."; 

in the first case I have to do
a1) mkfs.btrfs --root-dir....  (create the archive)
a2) dd  (copy and truncate the image and store it in the archive)
a3) dd  (take the archived image, and restore it)
a4) btrfs fi resize (expand the image)

in the second case I have to 
b1) tar cf ... (create the image an store it in the archive, this is a1+a2)
b2) mkfs,btrfs (create the filesystem with the final size)
b3) tar xf ... (take the archived image and restore it)


However the code is already written (and it seems simple enough), so a possible compromise could be to have the "shrinking" only if another option is passed; eg.

mkfs.btrfs --root ...                --> populate the filesystem
mkfs.btrfs --shrink --root           --> populate and shrink the filesystem 

however I find this useful only if it is possible to creating the filesystem in a file; ie.

mkfs.btrfs --shrink --root <path-to-source-fs> <file-to-be-created>

where <file-to-be-created> doesn't have to exists before mkfs.btrfs, and after 
a) <file-to-be-created> contains the image
b) <file-to-be-created> is the smallest possible size.

Definitely I don't like the truncate done by the operator by hand after the mkfs.btrfs (current behavior).

BTW I compiled successfully the patches, and these seems to work. 

PS: I tried to cross-compile mkfs.btrfs ton arm, but mkfs.btrfs was unable to work:

$ uname -a
Linux bananapi 4.4.66-bananian #2 SMP Sat May 6 19:26:50 UTC 2017 armv7l GNU/Linux
$ sudo ./mkfs.btrfs /dev/loop0
btrfs-progs v4.12.1-5-g3c9451cd
See http://btrfs.wiki.kernel.org for more information.

ERROR: superblock magic doesn't match
Performing full device TRIM /dev/loop0 (10.00GiB) ...
ERROR: open ctree failed

However this problem exists even with a plain v4.12.1. The first error seems to suggest that there is some endian-ness issue

BR
G.Baroncelli

> 
> I had a discussion with Austin about this, thread named "[btrfs-progs] Bug in mkfs.btrfs -r".
> The only equivalent I found is "mkfs.ext4 -d", which can only create new file if size is given and will not shrink fs.
> (Genext2fs shrinks the fs, but is no longer in e2fsprogs)
> 
> If we follow that behavior, the 3rd and 5th patches are not needed, which I'm pretty happy with.
> 
> Functionally, both behavior can be implemented with current method, but I hope to make sure which is the designed behavior so I can stick to it.
> 
> I hope you could make the final decision on this so I can update the patchset.
> 
> Thanks,
> Qu
> 
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
