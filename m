Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-2.tng.de ([213.178.66.96]:52139 "EHLO smtp2-2.tng.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2FMOBx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 10:01:53 -0400
Received: from smtp.tng.de (proxy02.mailcluster.tng.de [82.97.146.16])
	by smtp2-2.tng.de (Postfix) with ESMTP id BE6E99C16D
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 16:01:51 +0200 (CEST)
Received: from [213.178.67.139] (myrmidia.tng.de [213.178.67.139])
	by smtp.tng.de (Postfix) with ESMTPSA id B772320481
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 16:01:51 +0200 (CEST)
Message-ID: <4FD89D4F.8090405@ki.tng.de>
Date: Wed, 13 Jun 2012 16:01:51 +0200
From: Jan-Hendrik Palic <billgotchy@ki.tng.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Computing size of snapshots approximatly
References: <4FD88465.3020303@ki.tng.de> <20120613132747.GB28932@carfax.org.uk>
In-Reply-To: <20120613132747.GB28932@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo, hi all,

On 13.06.2012 15:27, Hugo Mills wrote:
> On Wed, Jun 13, 2012 at 02:15:33PM +0200, Jan-Hendrik Palic wrote:
>> Hi,
>>
>> we using on a server several lvm volumes with btrfs. We want to use
>> nightly build snapshots for some days as an alternative to backups.
>>
>> Now I want to get the size of the snapshots in detail.
>
>     There are basically two figures you can get for each snapshot.
> These values may differ wildly. Which one do you want?
>
> (A) The first, larger, value is the total computed size of the
>     files in the subvolume. This is what du returns.
>
> (B) The second, smaller, value is the amount of space that would be
>     freed by deleting the subvolume. (Alternatively, this is the amount
>     of data in the subvolume which is not shared with some other
>     subvolume). It is currently a difficult process to work out this
>     value in general, but the qgroups patch set will track this
>     information automatically, and expose an API that will allow you to
>     retrieve it.
>
>     The qgroups patches aren't complete yet.

Sorry, that I forgot to mention that. I want the size which I will get, 
if I delete a snapshot. The next assumption I forgot, sorry, was, that 
the snapshot are not changing. The user only get readonly access to the 
snapshots.

[...]
>> There are three operations on a filesystem, I think,
>>
>> 1. copy a file on the filesystem
>> 2. change a file on the filesystem
>> 3. delete a file on the filesystem
>>
>> Am I right to assume, that operation 1 and 2 are not change much the
>> size of a snapshot and the delete operation let increase the size of
>> a snapshot in the size of the deleted files?
>
>     It depends on which measure of the two above you're trying to use,
> and whether the subvolume (and file) you're modifying still has
> extents shared with some other subvolume.

Sure, and honestly, this is the point, where the complexity is exploding 
for me. ,-)

> 1. Copying a file (without --reflink) will increase both the (A) and
>     the (B) size of the snapshot. Copying a file with --reflink will
>     increase (A) and leave (B) much the same.

Yep.

> 2. Changing a file will, obviously, cause (A) to change by the
>     difference between the old file and the new. If that file shares no
>     extents with anything else, then (B) will also change by that
>     amount. Otherwise, if it shares extents with anything else (another
>     subvolume, or a reflink copy), then (B) will increase by the amount
>     of data modified.

Yep.

> 3. Deleting a file will reduce (A) by the size of the file. (B) will
>     reduce by the size of non-shared extents owned by that file.

Yep.

I think, I got the right thought. Thanks for the explanation.

>     Note that btrfs sub find-new will not allow you to track file
> deletions.

Yep, I got this to. But you can get them not directly by a diff.

You have a subvolume with a file_A on it.
Taking a snapshot snap_A of this subvolume let show the existence of 
that file in the btrfs sub find-new output.

Now delete the fila_A on this subvolume and take a new snapshot, call it 
snap_B.
The btrfs sub find-new output doesn't show it anymore, right. So, a diff 
of the both outputs, from snap_A to snap_B gives you the deleted file.

It is a cruel way, but I think, that it is working.

>> If it is so, it would be enough for me to get the deletions of files
>> between two snapshots and their size. But is there another way to
>> get these informations beside btrfs subvolume find-new? Perhaps it
>> makes sense to use ioctl for it? What about the send/receive
>> feature, which is upcoming?
>>
>> Are there any hints?
>     Wait for qgroups to land, because that actually does it the right
> way, and will avoid you having to track all kinds of awkward (and
> hard-to-find) corner cases.

Thanks for the hint, I will have a look for that.

Best regards,
Jan
