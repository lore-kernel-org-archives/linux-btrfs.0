Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52476 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbcFJDkF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 23:40:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 061CF20E18
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 23:40:03 -0400 (EDT)
Received: from ebox.rath.org (ebox.rath.org [45.79.69.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id AA266CC070
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 23:40:03 -0400 (EDT)
Received: from vostro.rath.org (vostro [192.168.12.4])
	by ebox.rath.org (Postfix) with ESMTPS id 466BD2E7BC3
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 03:40:02 +0000 (UTC)
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: fsck: to repair or not to repair
References: <87y47g1esh.fsf@thinkpad.rath.org>
Date: Thu, 09 Jun 2016 20:40:01 -0700
In-Reply-To: <87y47g1esh.fsf@thinkpad.rath.org> (Nikolaus Rath's message of
	"Wed, 11 May 2016 14:10:54 -0700")
Message-ID: <87fuslg19q.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 11 2016, Nikolaus Rath <Nikolaus@rath.org> wrote:
> Hello,
>
> I recently ran btrfsck on one of my file systems, and got the following
> messages:
>
> checking extents
> checking free space cache
> checking fs roots
> root 5 inode 3149867 errors 400, nbytes wrong
> root 5 inode 3150237 errors 400, nbytes wrong
> root 5 inode 3150238 errors 400, nbytes wrong
> root 5 inode 3150242 errors 400, nbytes wrong
> root 5 inode 3150260 errors 400, nbytes wrong
> [ lots of similar message with different inode numbers ]
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
>
> Can someone explain to me the risk that I run by attempting a repair,
> and (conversely) what I put at stake when continuing to use this file
> system as-is?
 
To follow-up on this: after finding out which files were affected (using
btrfs inspect-internal), I was able to fix the problem without using
btrfsck by simply copying the data, deleting the file, and restoring it:

cat affected-files.txt | while read -r name; do
rsync -a "${name}" "/backup/location/${name}"
rm -f "${name}"
cp -a "/backup/location/${name}" "${name}"
done

(I used rsync to avoid cp making use of reflinks). After this procedure,
btrfschk reported no more problems.


Best,
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
