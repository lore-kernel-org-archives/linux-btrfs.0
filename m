Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:60651 "EHLO
        smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbcIDTXn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 15:23:43 -0400
From: "Hendrik Friedel" <hendrik@friedels.name>
To: "Chris Murphy" <lists@colorremedies.com>
Subject: Re[4]: btrfs check "Couldn't open file system" after error in transaction.c
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Date: Sun, 04 Sep 2016 19:23:33 +0000
Message-Id: <eme5309cc5-7dc0-40a0-8b0e-318a2a3459ef@laptophendrik>
In-Reply-To: <em5bdcb5a1-be8c-43a7-a360-87ae4971a5c7@laptophendrik>
References: <em54d2d608-3b06-4e46-b795-214cf333e788@laptophendrik>
 <CAJCQCtRDJ0_pEqtNiQWJoibO=QT-TfF8c7RE7KmF0KZU4T-=OA@mail.gmail.com>
 <em6202fbe3-160c-4002-9576-59e892fedcd0@laptophendrik>
 <em5bdcb5a1-be8c-43a7-a360-87ae4971a5c7@laptophendrik>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

here the output of btrfsck:
Checking filesystem on /dev/sdd
UUID: a8af3832-48c7-4568-861f-e80380dd7e0b
checking extents
checking free space cache
checking fs root
checking csums
checking root refs
checking quota groups
Ignoring qgroup relation key 24544
Ignoring qgroup relation key 24610
Ignoring qgroup relation key 24611
Ignoring qgroup relation key 25933
Ignoring qgroup relation key 25934
Ignoring qgroup relation key 25935
Ignoring qgroup relation key 25936
Ignoring qgroup relation key 25937
Ignoring qgroup relation key 25938
Ignoring qgroup relation key 25939
Ignoring qgroup relation key 25939
Ignoring qgroup relation key 25941
Ignoring qgroup relation key 25942
Ignoring qgroup relation key 25958
Ignoring qgroup relation key 25959
Ignoring qgroup relation key 25960
Ignoring qgroup relation key 25961
Ignoring qgroup relation key 25962
Ignoring qgroup relation key 25963
Ignoring qgroup relation key 25964
Ignoring qgroup relation key 25965
Ignoring qgroup relation key 25966
Ignoring qgroup relation key 25966
Ignoring qgroup relation key 25968
Ignoring qgroup relation key 25970
Ignoring qgroup relation key 25971
Ignoring qgroup relation key 25972
Ignoring qgroup relation key 25975
Ignoring qgroup relation key 25976
Ignoring qgroup relation key 25976
Ignoring qgroup relation key 25976
Ignoring qgroup relation key 567172078071971871
Ignoring qgroup relation key 567172078071971872
Ignoring qgroup relation key 567172078071971882
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971885
Ignoring qgroup relation key 567172078071971886
Ignoring qgroup relation key 567172078071971886
Ignoring qgroup relation key 567172078071971886
Ignoring qgroup relation key 567172078071971886
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Ignoring qgroup relation key 567172078071971892
Qgroup is already inconsistent before checking
Counts for qgroup id: 3102 are different
our:            referenced 174829252608 referenced compressed 
174829252608
disk:           referenced 174829252608 referenced compressed 
174829252608
our:            exclusive 2899968 exclusive compressed 2899968
disk:           exclusive 2916352 exclusive compressed 2916352
diff:           exclusive -16384 exclusive compressed -16384
Counts for qgroup id: 25977 are different
our:            referenced 47249391616 referenced compressed 47249391616
disk:           referenced 47249391616 referenced compressed 47249391616
our:            exclusive 90222592 exclusive compressed 90222592
disk:           exclusive 90238976 exclusive compressed 90238976
diff:           exclusive -16384 exclusive compressed -16384
Counts for qgroup id: 25978 are different
our:            referenced 174829252608 referenced compressed 
174829252608
disk:           referenced 174829252608 referenced compressed 
174829252608
our:            exclusive 1064960 exclusive compressed 1064960
disk:           exclusive 1081344 exclusive compressed 1081344
diff:           exclusive -16384 exclusive compressed -16384
Counts for qgroup id: 26162 are different
our:            referenced 65940500480 referenced compressed 65940500480
disk:           referenced 65866997760 referenced compressed 65866997760
diff:           referenced 73502720 referenced compressed 73502720
our:            exclusive 3991326720 exclusive compressed 3991326720
disk:           exclusive 3960582144 exclusive compressed 3960582144
diff:           exclusive 30744576 exclusive compressed 30744576
found 8423479726080 bytes used err is 1
total csum bytes: 8206766844
total tree bytes: 17669144576
total fs tree bytes: 7271251968
total extent tree bytes: 683851776
total csum bytes: 8206766844
total tree bytes: 17669144576
total fs tree bytes: 7271251968
total extent tree bytes: 683851776
btree space waste bytes: 2859469730
file data blocks allocated: 16171232772096
referenced 13512171663360

What does that tell us?

Greetings,
Hendrik


------ Originalnachricht ------
Von: "Hendrik Friedel" <hendrik@friedels.name>
An: "Chris Murphy" <lists@colorremedies.com>
Cc: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Gesendet: 04.09.2016 20:51:06
Betreff: Re[3]: btrfs check "Couldn't open file system" after error in 
transaction.c

>Hello again,
>
>before overwriting the filesystem, some last questions:
>
>>>  Maybe
>>>take advantage of the fact it does read only and recreate it. You
>>>could take a btrfs-image and btrfs-debug-tree first,
>>And what do I do with it?
>>
>>>because there's
>>>some bug somewhere: somehow it became inconsistent, and can't be 
>>>fixed
>>>at mount time or even with btrfs check.
>>Ok, so is there any way to help you finding this bug?
>Anything, I can do here?
>
>>Coming back to my objectives:
>>-Understand the reason behind the issue and prevent it in future
>>Finding the but would help on the above
>>
>>-If not possible to repair the filesystem:
>>    -understand if the data that I read from the drive is valid or 
>>corrupted
>>Can you answer this?
>>
>>As mentioned: I do have a backup, a month old. The data does not 
>>change so regularly, so most should be ok.
>>Now I have two sources of data:
>>the backup and the current degraded filesystem.
>>If data differs, which one do I take? Is it safe to use the more 
>>recent one from the degraded filesystem?
>>
>And can you help me on these points?
>
>FYI, I did a
>btrfsck --init-csum-tree /dev/sdd
>btrfs rescue zero-log btrfs-zero-log
>btrfsck /dev/sdd
>
>now. The last command is still running. It seems to be working; Is 
>there a way to be sure, that the data is all ok again?
>
>Regards,
>Hendrik
>
>
>>
>>Greetings,
>>Hendrik
>>
>>>
>>>
>>>
>>>
>>>--
>>>Chris Murphy


---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

