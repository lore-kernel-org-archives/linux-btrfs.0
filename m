Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36767 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbIONSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 09:18:04 -0400
Received: by igcrk20 with SMTP id rk20so13725737igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 06:18:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <24glcc-3fb.ln1@hurikhan77.spdns.de>
References: <CAFQJxq57ZOsMy0TFpqSMNwtRaQcVp5x+gV69P-=mxL=mHD7sig@mail.gmail.com>
 <24glcc-3fb.ln1@hurikhan77.spdns.de>
From: "Marc O'Morain" <marc@circleci.com>
Date: Tue, 15 Sep 2015 14:17:44 +0100
Message-ID: <CAFQJxq7najUNQUC3FARG_mBVQezWs7-kAf=2+7vKkmqU9Vh26Q@mail.gmail.com>
Subject: Re: Intended destination for symlinks after subvolume snapshot
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 September 2015 at 13:38, Kai Krakow <hurikhan77@gmail.com> wrote:
> Marc O'Morain <marc@circleci.com> schrieb:
>
>> Hi all,
>>
>> What is the intended destination of a symlink inside a subvolume after
>> a snapshot?
>>
>> When I take a snapshot of a subvolume that contains a symlink, the
>> symlink points outside the snapshot and into the original subvolume.
>>
>> Is this the intended behaviour? Or should the symlinks be patched up
>> to point inside the snapshot?
>>
>> Here is an example that creates a new subvolume, a file and a symlink
>> to the file. It then creates a snapshot and shows the destination of
>> the symlink.
>>
>> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# mount | grep btrfs
>> /dev/loop0 on /mnt/btrfs type btrfs (rw)
>> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# btrfs subvolume create
>> subvolume0 Create subvolume './subvolume0'
>> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# touch subvolume0/readme.txt
>> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# ln -s
>> /mnt/btrfs/subvolume0/readme.txt /mnt/btrfs/subvolume0/readme.lnk
>> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# btrfs subvolume snapshot -r
>> subvolume0 snapshot0
>> Create a readonly snapshot of 'subvolume0' in './snapshot0'
>> root@vagrant-ubuntu-trusty-64:/mnt/btrfs# tree
>> .
>> ├── snapshot0
>> │   ├── readme.lnk -> /mnt/btrfs/subvolume0/readme.txt
>> │   └── readme.txt
>> └── subvolume0
>>     ├── readme.lnk -> /mnt/btrfs/subvolume0/readme.txt
>>     └── readme.txt
>>
>> 2 directories, 4 files
>>
>> (I was expecting snapshot0/reame.lnk to point to
>> /mnt/btrfs/snapshot0/readme.txt)
>
> If you use absolute symlinks this is intended behaviour and probably has its
> use cases (similar to when you move subdirectories or create a copy,
> symlinks aren't rewritten either).
>
> You should use relative symlinks for your use case (this means, do not start
> with "/", instead walk up with ".." if needed).

Thanks Kai.
