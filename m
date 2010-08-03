From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: wanted X found X-1 but you got X-2
Date: Tue, 03 Aug 2010 21:07:03 +0800
Message-ID: <4C581477.4030907@cn.fujitsu.com>
References: <20100729131103.323870@gmx.net> <4C526516.30709@cn.fujitsu.com> <20100730071354.257500@gmx.net> <20100731163424.105410@gmx.net> <4C56199B.8090400@cn.fujitsu.com> <20100802193716.107960@gmx.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org, liubo2009@cn.fujitsu.com
To: Adi <adalbert.b@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100802193716.107960@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Adi

On Mon, 02 Aug 2010 21:37:16 +0200, Adi wrote:
> now i get that error (on btrfsck):
>
> parent transid verify failed on 5403553792 wanted 103380 found 103378
> btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
>
> if i want to mount it, it shows the same error in dmesg, but neither one hangs the terminal, as it did without the patches.
> do you need more debug? i didn't know how to activate it on gentoo, what flags do i need to do so?

I don't know the detailed reproduce steps.Could you tell us the steps
just  like this?
# mkfs.btrfs /dev/sdaN
# mount /dev/sdaN /mnt
# dd ......
# (suspend-to-disk)
...

It is very useful for our analysis.

Thanks
Miao

> hm, and the last patch didn't show any output on "patch -p1"... is that normal?
>
> bye, adi
>
> -------- Original-Nachricht --------
>> Datum: Mon, 02 Aug 2010 09:04:27 +0800
>> Von: Miao Xie<miaox@cn.fujitsu.com>
>> An: Adi<adalbert.b@gmx.de>
>> CC: liubo2009@cn.fujitsu.com, linux-btrfs@vger.kernel.org
>> Betreff: Re: wanted X found X-1 but you got X-2
>
>> Hi, Adi
>>
>> On Sat, 31 Jul 2010 18:34:24 +0200, Adi wrote:
>>> ok, i have tried the 2.6.35-rc6 kernel, as TiCPU on #btrfs suggested,
>> but i also got an error. i don't think it has something to do with kcrypt, as
>> i can mount another partition without any problems.
>> [snip]
>>> ------------[ cut here ]------------
>>> kernel BUG at fs/btrfs/async-thread.c:603!
>>> invalid opcode: 0000 [#1] PREEMPT
>> [snip]
>> It seems this problem is the same as the one I have fixed.
>> Could you try to applied the following patches and test again?
>>     http://lkml.org/lkml/2010/7/29/86
>>     http://lkml.org/lkml/2010/7/29/84
>>     http://lkml.org/lkml/2010/7/29/82
>>
>> Thanks
>> Miao
>

