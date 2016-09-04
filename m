Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:47671 "EHLO
        smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbcIDSxK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 14:53:10 -0400
From: "Hendrik Friedel" <hendrik@friedels.name>
To: "Chris Murphy" <lists@colorremedies.com>
Subject: Re[3]: btrfs check "Couldn't open file system" after error in transaction.c
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Date: Sun, 04 Sep 2016 18:51:06 +0000
Message-Id: <em5bdcb5a1-be8c-43a7-a360-87ae4971a5c7@laptophendrik>
In-Reply-To: <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
 <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com>
 <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello again,

before overwriting the filesystem, some last questions:

>>  Maybe
>>take advantage of the fact it does read only and recreate it. You
>>could take a btrfs-image and btrfs-debug-tree first,
>And what do I do with it?
>
>>because there's
>>some bug somewhere: somehow it became inconsistent, and can't be fixed
>>at mount time or even with btrfs check.
>Ok, so is there any way to help you finding this bug?
Anything, I can do here?

>Coming back to my objectives:
>-Understand the reason behind the issue and prevent it in future
>Finding the but would help on the above
>
>-If not possible to repair the filesystem:
>    -understand if the data that I read from the drive is valid or 
>corrupted
>Can you answer this?
>
>As mentioned: I do have a backup, a month old. The data does not change 
>so regularly, so most should be ok.
>Now I have two sources of data:
>the backup and the current degraded filesystem.
>If data differs, which one do I take? Is it safe to use the more recent 
>one from the degraded filesystem?
>
And can you help me on these points?

FYI, I did a
btrfsck --init-csum-tree /dev/sdd
btrfs rescue zero-log btrfs-zero-log
btrfsck /dev/sdd

now. The last command is still running. It seems to be working; Is there 
a way to be sure, that the data is all ok again?

Regards,
Hendrik


>
>Greetings,
>Hendrik
>
>>
>>
>>
>>
>>--
>>Chris Murphy


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

