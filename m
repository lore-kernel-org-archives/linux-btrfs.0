Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3KGTQi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 14:16:38 -0500
Message-ID: <527BE712.40304@friedels.name>
Date: Thu, 07 Nov 2013 20:16:34 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck errors is it save to fix?
References: <52742B59.3060405@friedels.name>	<CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>	<5274BEC8.5060804@friedels.name>	<52780E20.8020405@friedels.name> <CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com> <5279E581.4000700@friedels.name>
In-Reply-To: <5279E581.4000700@friedels.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello again,

can someone please help me on this?

Regards,
Hendrik

Am 06.11.2013 07:45, schrieb Hendrik Friedel:
> Hello,
>
> sorry, I was totally unaware still being on 3.11rc2.
>
> I re-ran btrfsck with the same result:
> ./btrfs-progs/btrfsck /dev/sdc1
> Checking filesystem on /dev/sdc1
> UUID: 989306aa-d291-4752-8477-0baf94f8c42f
> checking extents
> checking free space cache
> checking fs roots
> root 256 inode 9579 errors 100
> root 256 inode 9580 errors 100
> root 256 inode 14258 errors 100
> root 256 inode 14259 errors 100
> root 4444 inode 9579 errors 100
> root 4444 inode 9580 errors 100
> root 4444 inode 14258 errors 100
> root 4444 inode 14259 errors 100
> found 1992865028914 bytes used err is 1
> total csum bytes: 3207847732
> total tree bytes: 3902865408
> total fs tree bytes: 38875136
> total extent tree bytes: 135864320
> btree space waste bytes: 411665032
> file data blocks allocated: 3426722545664
>   referenced 3426000965632
> Btrfs v0.20-rc1-358-g194aa4a
>
>
> Now dmesg and the syslog stay clear of entries relatet to btrfs.
> But I think, that might also be a coincidence: I ran the old Kernel for
> weeks until this error came, whereas I ran this kernel merely 12h.
>
> Now:
> Does it make sense to futher try to find a possible bug, or do we
> suspect it is fixed? If so: How can I help?
>
> And:
> Can I fix these Problems safely with btrfsck?
>
> Regards,
> Hendrik
>
> Am 05.11.2013 03:03, schrieb cwillu:
>> On Mon, Nov 4, 2013 at 3:14 PM, Hendrik Friedel
>> <hendrik@friedels.name> wrote:
>>> Hello,
>>>
>>> the list was quite full with patches, so this might have been hidden.
>>> Here the complete Stack.
>>> Does this help? Is this what you needed?
>>>> [95764.899294] CPU: 1 PID: 21798 Comm: umount Tainted: GF        CIO
>>>> 3.11.0-031100rc2-generic #201307211535
>>
>> Can you reproduce the problem under the released 3.11 or 3.12?  An
>> -rc2 is still pretty early in the release cycle, and I wouldn't be at
>> all surprised if it was a bug added and fixed in a later rc.
>>
>
>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
