Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35564 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2FQTyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jun 2012 15:54:47 -0400
Received: by obbtb18 with SMTP id tb18so7374244obb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Jun 2012 12:54:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm-uBVR4U+=LoMQjUbJEwZ-+FDOdLNmgc+P=gKQzC6G=jQ@mail.gmail.com>
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com>
 <20120616145704.039809d2@sf.home> <CAJs9aZ-9EK2HUuvBDuiPSG2O5J16seO6Hp3=wJLYAJBi9KDL+Q@mail.gmail.com>
 <CAJs9aZ_C5CzyuudeUg585M4SifunchrmVDg5rXQoo7kDAsOMpw@mail.gmail.com>
 <1339910379.1538.4.camel@ierdnac-hp> <CAJs9aZ-bTEPyJBiLxQozu71-atP958wp95HhyfFgTb+2y2kLLA@mail.gmail.com>
 <CAKcLGm-uBVR4U+=LoMQjUbJEwZ-+FDOdLNmgc+P=gKQzC6G=jQ@mail.gmail.com>
From: rupert THURNER <rupert.thurner@gmail.com>
Date: Sun, 17 Jun 2012 21:54:26 +0200
Message-ID: <CAJs9aZ94RcRR9MYC0bT81VfMuURDqA2-R2iiN3=Y_8sz7caHpw@mail.gmail.com>
Subject: Re: cannot remove files: "rm" gives "no space left on device",
 3.2.0-24, ubuntu
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: ierdnah@gmail.com, Sergei Trofimovich <slyich@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 17, 2012 at 3:32 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Sun, Jun 17, 2012 at 3:04 AM, rupert THURNER
> <rupert.thurner@gmail.com> wrote:
>> On Sun, Jun 17, 2012 at 7:19 AM, Andrei Popa <ierdnah@gmail.com> wrote:
>>> On Sun, 2012-06-17 at 06:14 +0200, rupert THURNER wrote:
>>>> >> Will result in anything reported in 'dmesg' output?
>>>> > [ 6431.514454] device label 388gb-data devid 1 transid 1086 /dev/sda6
>>>> > [ 6431.514969] btrfs: disabling disk space caching
>>>> > [ 6431.514977] btrfs: force clearing of disk cache
>>>> tried the same with kernel versions from
>>>> http://kernel.ubuntu.com/~kernel-ppa/mainline/:
>>>> * 3.2.20
>>>> * 3.4.0
>>>> with version 3.4.0, i could delete one tiny file, but only one. peter
>>>> mentioned before to run the rm as root. yes, i did that, with all
>>>> kernel versions, the error was the same all the time.
>>>
>>> Have you tried to delete the files with "echo > file" ? This will empty
>>> the file without requiring a new metadata allocation.
>>
>> thanks for the hint! i did with the original kernel, but now i tried
>> it as root and with the 3.4.0 kernel as well. "no space left on
>> device". is there a  special kernel version or a special btrfs tool
>> which allows to remove a file without writing more data?
>>
>
> Have you tried mounting with '-o nodatacow' yet?

this time i booted with the 3.2.20 kernel, as it seems the newewst.
root@tv:~# uname -a
Linux tv 3.2.20-030220-generic #201206102035

mount '-onospace_cache,clear_cache,enospc_debug,nodatacow'
/dev/sda6/media/388gb-data/

dmesg
[  668.229436] btrfs: fail to dirty inode 12714241 error -28
[  668.232904] btrfs: fail to dirty inode 22544659 error -28
[  668.233337] btrfs: fail to dirty inode 22544661 error -28
[  668.263847] btrfs: fail to dirty inode 256 error -28
[  693.740732] btrfs: fail to dirty inode 14811391 error -28


echo > /media/388gb-data/bigfile
--> worked

then rm of other big files was working as well. the dirty inode
messages in dmesg are gone as well after unmount and mount. and the df
displays the additional free space. that it displays 30% of metadata
seems strange to me, or it counts the still existing ext4 snapshot
from the conversion somehow into it?

root@tv:~# btrfs filesystem df /media/388gb-data
Data: total=260.59GB, used=251.51GB
System: total=32.00MB, used=24.00KB
Metadata: total=128.00GB, used=120.00GB

i included the "nodatacow" option as workaround on the btrfs wikipage,
ubuntu, as well:
https://btrfs.wiki.kernel.org/index.php/Ubuntu_support#Ubuntu_Linux_12.04_.28Precise_Pangolin.29

what would you recommend to do for "normal" usage? one should not
always use the "nodatacow" option, isn't it?

rupert.
