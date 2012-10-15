Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49222 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2JOTm5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 15:42:57 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so3267031wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 12:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507C6239.1030208@profihost.ag>
References: <50771F22.3070501@profihost.ag>
	<20121011194335.GE4405@twin.jikos.cz>
	<50772408.9040303@profihost.ag>
	<507BE264.1060500@cn.fujitsu.com>
	<507C6239.1030208@profihost.ag>
Date: Mon, 15 Oct 2012 21:42:54 +0200
Message-ID: <CAOcd+r2sZYxxNRQS2h-LY9Fpd791JRKiVq2gT-xBpkPY8=FsQQ@mail.gmail.com>
Subject: Re: problems with btrfs send / restore
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: miaox@cn.fujitsu.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

Is /btrfs/target/\@snapshot/ a subvolume or a directory?

can you pls try the patch that I posted here:
http://www.spinics.net/lists/linux-btrfs/msg19583.html

I feel that you're hitting a similar issue here. Before you apply the
patch, please verify that you have /etc/mtab on your system (I will
make a more formal patch later).

Thanks,
Alex.


On Mon, Oct 15, 2012 at 9:21 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
> Am 15.10.2012 12:16, schrieb Miao Xie:
>
>> On      thu, 11 Oct 2012 21:54:48 +0200, Stefan Priebe wrote:
>>>
>>> Am 11.10.2012 21:43, schrieb David Sterba:
>>>>
>>>> On Thu, Oct 11, 2012 at 09:33:54PM +0200, Stefan Priebe wrote:
>>>>>
>>>>> [server: /btrfs/target]# btrfs send -i /btrfs/src/\@snapshot/1
>>>>> /btrfs/src/\@snapshot/2 | btrfs receive /btrfs/target/\@snapshot/
>>>>> At subvol /btrfs/src/@snapshot/2
>>>>> At subvol 2
>>>>> ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No
>>>>> such file or directory
>>>>
>>>>                                         ^^^^^^^^^^^^^^^^^^^
>>>>
>>>> I wonder if this is the ghost snapshot dir entry that Miao fixed. Did
>>>> somehow get into the 'send' stream and confused the receive side.
>>>>
>>>> david
>>>
>>>
>>> i missed two facts:
>>> 1.) vanilla kernel 3.6.1
>>> 2.) latest btrfs tools git (cloned at 10/10/2012)
>>
>>
>> Sorry, I can not reproduce this problem, could you send me the detailed
>> steps?
>
>
> mhm there is nothing special. But i try to provide more information / a
> small howto:
>
> # mount |grep btrfs
> /dev/sdb on /btrfs/src type btrfs (rw)
> /dev/sdc on /btrfs/target type btrfs (rw)
>
> # btrfs subvolume list /btrfs/target/
> # btrfs subvolume list /btrfs/src/
> ID 277 top level 5 path @snapshot/1
> ID 278 top level 5 path @snapshot/2
> ID 288 top level 5 path @snapshot/3
>
> # btrfs send /btrfs/src/\@snapshot/1 | btrfs receive
> /btrfs/target/\@snapshot/
> At subvol /btrfs/src/@snapshot/1
> At subvol 1
> #
>
> Now i was trying to send an incremental snapshot:
>
> # btrfs send -i /btrfs/src/\@snapshot/1 /btrfs/src/\@snapshot/2 | btrfs
> receive /btrfs/target/\@snapshot/
> At subvol /btrfs/src/@snapshot/2
> At subvol 2
> ERROR: failed to open /btrfs/target/@snapshot/@snapshot/1/test.tar. No such
> file or directory
> #
>
> Greets,
>
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
