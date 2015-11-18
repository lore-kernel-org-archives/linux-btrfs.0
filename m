Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34787 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbbKRFSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 00:18:52 -0500
Received: by lffu14 with SMTP id u14so19179647lff.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2015 21:18:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564BEA55.4040209@gmx.com>
References: <CA+xOVSMpsSNfBxOghUe8H2QhzLDTC8EAABwkvrE12hUOFmfDig@mail.gmail.com>
	<564BEA55.4040209@gmx.com>
Date: Wed, 18 Nov 2015 07:18:50 +0200
Message-ID: <CA+xOVSMN+_H546rx3UCQht1yYd6F9KLr1vzAfK+JVHJXUF0rOw@mail.gmail.com>
Subject: Re: Transaction aborted (error -17) after crash
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

On Wed, Nov 18, 2015 at 5:02 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> 在 2015年11月17日 13:12, Mordechay Kaganer 写道:
>>
>> B.H.
>>
>>
>> [  836.026606] BTRFS warning (device md1): block group 12969790406656
>> has wrong amount of free space
>> [  836.026610] BTRFS warning (device md1): failed to load free space
>> cache for block group 12969790406656, rebuild it now
>> [ 1033.619798] BTRFS warning (device md1): block group 15322358743040
>> has wrong amount of free space
>> [ 1033.619801] BTRFS warning (device md1): failed to load free space
>> cache for block group 15322358743040, rebuild it now
>
>
> Block group seems to be corrupted, maybe some other place in extent tree is
> also corrupted.
>
> Personally speaking, this would not be a huge problem and can be fix by
> btrfsck --init-extent-tree --repair to fix it.

Thanks. That's what i get so far (it takes several hours to complete
because the partition is huge):

# btrfsck --init-extent-tree --repair /dev/md1
enabling repair mode
Checking filesystem on /dev/md1
UUID: e16cc571-d897-473a-91d3-7673ea91d4cc
Creating a new extent tree
Failed to find [12968716681216, 168, 16384]
btrfs unable to find ref byte nr 12968927035392 parent 0 root 1  owner
1 offset 0
Failed to find [12968716730368, 168, 16384]
btrfs unable to find ref byte nr 12969060089856 parent 0 root 1  owner
0 offset 1
parent transid verify failed on 1103806464 wanted 19 found 13821
Ignoring transid failure
Failed to find [12968716779520, 168, 16384]
btrfs unable to find ref byte nr 12968933851136 parent 0 root 1  owner
0 offset 1

Does it mean something screwed up and unrecoverable?

>
> But you must ensure other tree is not corrupted, by using btrfsck without
> any option to check the filesystem.

I did run btrfs check --repair without other options. Finished without
problems as far as i understand the output. Also tried mount with -o
clear_cache. All this doesn't seem to help - tried rsync after that
and the FS went read only with the same error message.

-- 
"ויעקב הלך לדרכו..."
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
