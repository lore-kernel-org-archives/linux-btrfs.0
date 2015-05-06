Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31076 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbbEFIMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 04:12:10 -0400
Message-ID: <5549CCD8.2010000@cn.fujitsu.com>
Date: Wed, 6 May 2015 16:12:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
In-Reply-To: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Works for me.
Although with a lot of annoying extra missing device warning:
------
$ sudo btrfs fi show
warning, device 1 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
warning, device 1 is missing
warning devid 1 not found already
warning devid 2 not found already
warning devid 3 not found already
warning devid 4 not found already
bytenr mismatch, want=40222720, have=0
Couldn't read tree root
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
Label: none  uuid: 7d57b997-1e84-4daf-a99c-a0339d268112
	Total devices 5 FS bytes used 6.98MiB
	devid    5 size 10.00GiB used 1.80GiB path /dev/sda6
	*** Some devices missing

Label: none  uuid: 54e051a4-0a9b-4ec5-b8bf-cecdd1ec6620
	Total devices 1 FS bytes used 991.94MiB
	devid    1 size 10.00GiB used 3.04GiB path /dev/sdb

Label: none  uuid: 2b4ca7ea-061a-4784-b2de-c7d6341ef8a0
	Total devices 1 FS bytes used 384.00KiB
	devid    1 size 15.00GiB used 2.04GiB path /dev/sdc

Label: none  uuid: c5a72536-5319-465e-81b6-a03468daab8a
	Total devices 4 FS bytes used 15.29MiB
	devid    2 size 10.00GiB used 2.01GiB path /dev/sdg
	devid    3 size 10.00GiB used 2.01GiB path /dev/sde
	devid    4 size 10.00GiB used 2.01GiB path /dev/sdf
	*** Some devices missing

btrfs-progs v4.0
------

Would you please give some detail of your problem?
Like the options and arguments.

Thanks,
Qu

-------- Original Message  --------
Subject: btrfs-progs 4.0 breaks btrfs fi show?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: 2015年05月06日 15:23

> Since the 4.0 update, fi show only gives me a version number. Anyone else?
>
> btrfs-progs-4.0-1.fc22.x86_64
> kernel-4.0.1-300.fc22.x86_64
>
>
