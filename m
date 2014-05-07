Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:36828 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbaEGNNm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 09:13:42 -0400
Received: by mail-qa0-f42.google.com with SMTP id j5so963176qaq.15
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 06:13:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEVbaUcV-M9jnwR4ii3zR6RrbfpCtMmYAmhp8O01T4T6jJQN4A@mail.gmail.com>
References: <CAEVbaUdcCQCWhZ-ZdBr_Dkv-WaMbtBkQ0n8HRfc0p9F0xw1+0A@mail.gmail.com>
 <20140507022245.GA15783@localhost.localdomain> <CAEVbaUcV-M9jnwR4ii3zR6RrbfpCtMmYAmhp8O01T4T6jJQN4A@mail.gmail.com>
From: Kenny MacDermid <kenny.macdermid@gmail.com>
Date: Wed, 7 May 2014 10:13:01 -0300
Message-ID: <CAEVbaUcRrxErXQ=5a66+28=MEZK+szzoPiwCDwZyZ=pDLTem+Q@mail.gmail.com>
Subject: Re: btrfs issues in 3.14
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 7, 2014 at 9:35 AM, Kenny MacDermid
<kenny.macdermid@gmail.com> wrote:
> On Tue, May 6, 2014 at 11:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>
>> What does sysrq+w say when the hang happens?
>
> The whole system isn't hung, I may have explained that wrong. The
> system will hang if I try to shutdown, and the process will hang if I
> try to kill -9 it.
>
> It looks like the browser is in this state currently so I did an 'echo
> w >/proc/sysrq-trigger' and have attached the full dmesg with the
> browser issues and the output.

I had to hard reboot to clear that issue, and I decided to do another
'btrfs check' while /home was unmounted. It generated the following
output:

checking extents
checking free space cache
Wanted bytes 45056, found 32768 for off 63805808640
Wanted bytes 111190016, found 32768 for off 63805808640
cache appears valid but isnt 62843256832
Checking filesystem on //dev/mapper/home
UUID: 9a60a25f-eeb4-494c-b1af-ebd8e4f79b6b
found 13672418478 bytes used err is -22
total csum bytes: 72089212
total tree bytes: 906100736
total fs tree bytes: 808370176
total extent tree bytes: 18153472
btree space waste bytes: 116247440
file data blocks allocated: 101046853632
 referenced 73680674816
Btrfs v3.14.1

This is on the new filesystem. I redid the dmcrypt and the lvm lv when
I recreated the filesystem as well, so it's less than a week old.
Before rebuilding the old was was telling me:

Checking filesystem on /dev/mapper/home
UUID: 4f5d7a10-d003-48a7-a901-bf22d534888f
free space inode generation (0) did not match free space cache
generation (115200)
found 29963117667 bytes used err is 1
total csum bytes: 63740440
total tree bytes: 745504768
total fs tree bytes: 624951296
total extent tree bytes: 36749312
btree space waste bytes: 119018687
file data blocks allocated: 181026942976
 referenced 73759866880
Btrfs v0.20-rc1-358-g194aa4a-dirty

and

checking extents
checking free space cache
checking fs roots
root 257 inode 29647 errors 200, dir isize wrong
root 257 inode 391917 errors 200, dir isize wrong
root 257 inode 497392 errors 410, odd dir item, nbytes wrong
Checking filesystem on /dev/mapper/home
UUID: 4f5d7a10-d003-48a7-a901-bf22d534888f
free space inode generation (0) did not match free space cache
generation (115200)
found 31310902624 bytes used err is 1
total csum bytes: 63579480
total tree bytes: 743342080
total fs tree bytes: 623198208
total extent tree bytes: 36601856
btree space waste bytes: 118906643
file data blocks allocated: 180831965184
 referenced 73631731712
Btrfs v3.14
