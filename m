Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39662 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169AbcELRfF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 13:35:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id AC3AC20DBE
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 13:35:03 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 5BFADC00016
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 13:35:03 -0400 (EDT)
Received: from thinkpad.rath.org (thinkpad [192.168.12.2])
	by ebox.rath.org (Postfix) with ESMTPS id 3A2DF2A3D79
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 17:35:02 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: fsck: to repair or not to repair
References: <87y47g1esh.fsf@thinkpad.rath.org>
	<CAPmG0jYDw8Sid2jORVtfwNLpeZPAqtH429EQsraz9GzNdK1aUQ@mail.gmail.com>
Date: Thu, 12 May 2016 10:35:01 -0700
In-Reply-To: <CAPmG0jYDw8Sid2jORVtfwNLpeZPAqtH429EQsraz9GzNdK1aUQ@mail.gmail.com>
	(Henk Slager's message of "Thu, 12 May 2016 19:02:56 +0200")
Message-ID: <878tzf18oq.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 12 2016, Henk Slager <eye1tm@gmail.com> wrote:
> On Wed, May 11, 2016 at 11:10 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:
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
>>
>> Can someone explain to me the risk that I run by attempting a repair,
>> and (conversely) what I put at stake when continuing to use this file
>> system as-is?
>
> It has once been mentioned in this mail-list, that if the 'errors 400,
> nbytes wrong' is the only error on an fs, btrfs check --repair can fix
> them ( was around time of tools release 4.4 , by Qu AFAIK).
> I had /(have?) about 7 of those errors in small files on an fs that is
> 2.5 years old and has quite some older ro snapshots. I once tried to
> fix them with 4.5.0 + some patches tools, but actually they did not
> get fixed. At least with 4.5.2 or 4.5.3 tools it should be possible to
> fix them in your case. Maybe you first want to test it on an overlay
> of the device or copy the whole fs with dd. It depends on how much
> time you can allow the fs to be offline etc, it is up to you.
>
> In my case, I recreated the files in the working subvol, but as long
[...]

How did you determine which files were affected? Is there a way to map
inodes to paths?


Thanks!
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
