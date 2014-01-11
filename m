Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:54189 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaAKWfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 17:35:14 -0500
Received: by mail-we0-f177.google.com with SMTP id x55so3104092wes.36
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 14:35:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5299CF4F.10706@friendlyvirus.org>
References: <1385743045-2969-1-git-send-email-wangshilong1991@gmail.com>
	<5299CF4F.10706@friendlyvirus.org>
Date: Sun, 12 Jan 2014 00:35:12 +0200
Message-ID: <CAOcd+r17_DmS=2nfAcvJdnPeH_jpEv0R-uSg6HtRzpDJPM004w@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs-progs: avoid using btrfs internal subvolume path
 to send
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miguel,

On Sat, Nov 30, 2013 at 1:43 PM, Miguel Negrão
<miguel.negrao-lists@friendlyvirus.org> wrote:
> Em 29-11-2013 16:37, Wang Shilong escreveu:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> Steps to reproduce:
>>       # mkfs.btrfs -f /dev/sda
>>       # mount /dev/sda /mnt
>>       # btrfs subvolume create /mnt/foo
>>       # umount /mnt
>>       # mount -o subvol=foo /dev/sda /mnt
>>       # btrfs sub snapshot -r /mnt /mnt/snap
>>       # btrfs send /mnt/snap > /dev/null
>>
>> We will fail to send '/mnt/snap',this is because btrfs send try to
>> open '/mnt/snap' by btrfs internal subvolume path 'foo/snap' rather
>> than relative path based on mounted point, this will return us 'no
>> such file or directory',this is not right, fix it.
>
> I was going to write to the list to report exactly this issue. In my
> case, this happens when the default subvolume has been changed from id 5
> to some other id. I get the error 'no such file or directory'. Currently
> my workaround is to mount the root subvolume with -o subvolid=5 and then
> do the send.
>
> Also, I'd like to ask, are there plans to make the send and receive
> commands resumeable somehow (or perhaps it is already, but couldn't see
> how) ?
I have proposed a patch to address the resumability of send-receive
some time ago in this thread:
http://www.spinics.net/lists/linux-btrfs/msg18180.html

However, this changes the current user-kernel protocol used by "send",
and overall a big change, which is not easy to integrate.

Alex.


>
> best,
> Miguel Negrão
>
>
>
