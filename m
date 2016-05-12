Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53195 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932805AbcELPqF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 11:46:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 9395720CA4
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 11:46:03 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id 9C913680194
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 11:46:02 -0400 (EDT)
Received: from thinkpad.rath.org (thinkpad [192.168.12.2])
	by ebox.rath.org (Postfix) with ESMTPS id 8094E2A3AB7
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 15:46:01 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Input/output error on newly created file
References: <8760uoqjlt.fsf@vostro.rath.org>
	<CAL3q7H4opJabDo6mBoQb3P8NeGS31=-5F3e4m8qWLs2fn6jL+Q@mail.gmail.com>
	<878tzilhf3.fsf@vostro.rath.org>
Date: Thu, 12 May 2016 08:46:00 -0700
In-Reply-To: <878tzilhf3.fsf@vostro.rath.org> (Nikolaus Rath's message of
	"Mon, 09 May 2016 20:29:20 -0700")
Message-ID: <87eg971dqf.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

*ping*

Anyone any idea?

Best,
-Nikolaus

On May 09 2016, Nikolaus Rath <Nikolaus@rath.org> wrote:
> On May 09 2016, Filipe Manana <fdmanana@gmail.com> wrote:
>> On Sun, May 8, 2016 at 11:18 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:
>>> Hello,
>>>
>>> I just created an innocent 10 MB on a btrfs file system, yet my attempt
>>> to read it a few seconds later (and ever since), just gives:
>>>
>>> $ ls -l in-progress/mysterious-io-error
>>> -rw-rw-r-- 1 nikratio nikratio 10485760 May  8 14:41 in-progress/mysterious-io-error
>>> $ cat in-progress/mysterious-io-error
>>> cat: in-progress/mysterious-io-error: Input/output error
>>
>> If you unmount and mount again the filesystem, does it happen again?
>
> After rebooting, the previously unaccessible file can now be read. But I
> cannot tell if it contains the right data.
>
> However, I just encountered the same problem with another, freshly
> created file.
>
>> How did you create the file?
>
> In Python 3. The equivalent code is more or less:
>
> with open('file.dat', 'wb+') as fh:
>      for buf in generate_data():
>          fh.write(buf) # bufsize is about 128 kB
>
>
> However, I should note that there is a lot of activity in this
> file system (it contains my home directory), so the above alone will
> probably not reproduce the problem.
>
> That said, so far both the problematic files were created by the same
> application (S3QL, of which luckily I am also the maintainer).
>
>
>> Does fsck reports any issues?
>
> Do you mean btrfsck? It actually has a lot to say:
>
> checking extents
> checking free space cache
> checking fs roots
> root 5 inode 3149867 errors 400, nbytes wrong
> root 5 inode 3150237 errors 400, nbytes wrong
> root 5 inode 3150238 errors 400, nbytes wrong
> root 5 inode 3150242 errors 400, nbytes wrong
> root 5 inode 3150260 errors 400, nbytes wrong
> [...]
> root 5 inode 15595011 errors 400, nbytes wrong
> root 5 inode 15595016 errors 400, nbytes wrong
> Checking filesystem on /dev/mapper/vg0-nikratio_crypt
> UUID: 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
> found 263648960636 bytes used err is 1
> total csum bytes: 395314372
> total tree bytes: 908644352
> total fs tree bytes: 352735232
> total extent tree bytes: 95039488
> btree space waste bytes: 156301160
> file data blocks allocated: 675209801728
>  referenced 410351722496
> Btrfs v3.17
>
> However, the inode of the problematic file (16186241) is not
> mentioned. But I guess this is not surprising, because also for this
> file, I can read the contents after remounting.
>
>
> Best,
> -Nikolaus
>
>
> -- 
> GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
> Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F
>
>              »Time flies like an arrow, fruit flies like a Banana.«
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
