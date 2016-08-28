Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:35326 "EHLO
        smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755677AbcH1SEd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 14:04:33 -0400
From: "Hendrik Friedel" <hendrik@friedels.name>
To: "Chris Murphy" <lists@colorremedies.com>
Subject: Re[2]: btrfs check "Couldn't open file system" after error in transaction.c
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Date: Sun, 28 Aug 2016 18:04:26 +0000
Message-Id: <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik>
In-Reply-To: <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
 <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

thanks for your reply -especially on a Sunday.
>>  I have a filesystem (three disks with no raid)
>
>So it's data single *and* metadata single?
>
No:
Data, single: total=8.14TiB, used=7.64TiB
System, RAID1: total=32.00MiB, used=912.00KiB
Metadata, RAID1: total=18.00GiB, used=16.45GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
>>  btrfs check will lead to  "Couldn't open file system"
>
>Try btrfs-progs all the most recent btrfs-progs to see if it's any
>different: 4.5.3, 4.6.1, 4.7 (or 4.7.1 if you can get it, it's days
>old).
Ok, I will try.
>>  [   98.534830] BTRFS error (device sde): parent transid verify failed 
>>on
>>  22168481054720 wanted 1826943 found 1828546
>
>
>That's pretty weird. It wants a LOWER generation number than what it
>found? By quite a bit. It's nearly 1500 generations different. I don't
>know what can cause this kind of confusion or how to fix it.
Ok, time to get the data off it (I do have backups, but of course some 
weeks old). Answering this question:
-If possible repair the filesystem
NO

>  Maybe
>take advantage of the fact it does read only and recreate it. You
>could take a btrfs-image and btrfs-debug-tree first,
And what do I do with it?

>because there's
>some bug somewhere: somehow it became inconsistent, and can't be fixed
>at mount time or even with btrfs check.
Ok, so is there any way to help you finding this bug?
Coming back to my objectives:
-Understand the reason behind the issue and prevent it in future
Finding the but would help on the above

-If not possible to repair the filesystem:
    -understand if the data that I read from the drive is valid or 
corrupted
Can you answer this?

As mentioned: I do have a backup, a month old. The data does not change 
so regularly, so most should be ok.
Now I have two sources of data:
the backup and the current degraded filesystem.
If data differs, which one do I take? Is it safe to use the more recent 
one from the degraded filesystem?

Greetings,
Hendrik

>
>
>
>
>--
>Chris Murphy


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

