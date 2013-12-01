Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40088 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3LABe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Nov 2013 20:34:57 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so10670244wgg.7
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Nov 2013 17:34:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP9B-QksjFo_G70QjThw-LRt=J8PxeRe-UuMgrhtub_R+b_+BQ@mail.gmail.com>
References: <1385743045-2969-1-git-send-email-wangshilong1991@gmail.com>
	<5299CF4F.10706@friendlyvirus.org>
	<CAP9B-QksjFo_G70QjThw-LRt=J8PxeRe-UuMgrhtub_R+b_+BQ@mail.gmail.com>
Date: Sun, 1 Dec 2013 09:34:56 +0800
Message-ID: <CAP9B-Q==hQpLvuc+oNFpzUDm=U=P-JOux_QJsxVU6JigWOaL4w@mail.gmail.com>
Subject: Fwd: [PATCH v2] Btrfs-progs: avoid using btrfs internal subvolume
 path to send
From: Shilong Wang <wangshilong1991@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cc:linux-btrfs

---------- Forwarded message ----------
From: Shilong Wang <wangshilong1991@gmail.com>
Date: 2013/12/1
Subject: Re: [PATCH v2] Btrfs-progs: avoid using btrfs internal
subvolume path to send
To: Miguel Negrão <miguel.negrao-lists@friendlyvirus.org>


Hello Miguel,

2013/11/30 Miguel Negrão <miguel.negrao-lists@friendlyvirus.org>:
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

This patch can also fix your case(that you change your default
subvolume and mounting with default subvolume)

> Also, I'd like to ask, are there plans to make the send and receive
> commands resumeable somehow (or perhaps it is already, but couldn't see
> how) ?

Nope, now, btrfs send is implemented in kernel space, while receive is
in userspace
totally.But i think canceling/resuming operation for  'btrfs send' is
meaningful.

Thanks,
Wang
>
> best,
> Miguel Negrão
>
>
>
