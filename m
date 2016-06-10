Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35018 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbcFJLFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 07:05:48 -0400
Received: by mail-io0-f181.google.com with SMTP id o127so16380233iod.2
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 04:05:48 -0700 (PDT)
Subject: Re: fsck: to repair or not to repair
To: Nikolaus Rath <Nikolaus@rath.org>, linux-btrfs@vger.kernel.org
References: <87y47g1esh.fsf@thinkpad.rath.org>
 <87fuslg19q.fsf@vostro.rath.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ec929c7d-079d-8ea5-87d7-fce0ed1c45b7@gmail.com>
Date: Fri, 10 Jun 2016 07:05:40 -0400
MIME-Version: 1.0
In-Reply-To: <87fuslg19q.fsf@vostro.rath.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-09 23:40, Nikolaus Rath wrote:
> On May 11 2016, Nikolaus Rath <Nikolaus@rath.org> wrote:
>> Hello,
>>
>> I recently ran btrfsck on one of my file systems, and got the following
>> messages:
>>
>> checking extents
>> checking free space cache
>> checking fs roots
>> root 5 inode 3149867 errors 400, nbytes wrong
>> root 5 inode 3150237 errors 400, nbytes wrong
>> root 5 inode 3150238 errors 400, nbytes wrong
>> root 5 inode 3150242 errors 400, nbytes wrong
>> root 5 inode 3150260 errors 400, nbytes wrong
>> [ lots of similar message with different inode numbers ]
>> root 5 inode 15595011 errors 400, nbytes wrong
>> root 5 inode 15595016 errors 400, nbytes wrong
>> Checking filesystem on /dev/mapper/vg0-nikratio_crypt
>> UUID: 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
>> found 263648960636 bytes used err is 1
>> total csum bytes: 395314372
>> total tree bytes: 908644352
>> total fs tree bytes: 352735232
>> total extent tree bytes: 95039488
>> btree space waste bytes: 156301160
>> file data blocks allocated: 675209801728
>>  referenced 410351722496
>> Btrfs v3.17
>>
>>
>> Can someone explain to me the risk that I run by attempting a repair,
>> and (conversely) what I put at stake when continuing to use this file
>> system as-is?
>
> To follow-up on this: after finding out which files were affected (using
> btrfs inspect-internal), I was able to fix the problem without using
> btrfsck by simply copying the data, deleting the file, and restoring it:
>
> cat affected-files.txt | while read -r name; do
> rsync -a "${name}" "/backup/location/${name}"
> rm -f "${name}"
> cp -a "/backup/location/${name}" "${name}"
> done
>
> (I used rsync to avoid cp making use of reflinks). After this procedure,
> btrfschk reported no more problems.
JFYI, if you've using GNU cp, you can pass '--reflink=never' to avoid it 
making reflinks.

