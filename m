Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52831 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaLQC4v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 21:56:51 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 4FD233EE194
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 11:56:50 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 51BF1AC0299
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 11:56:49 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id EF997E08002
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 11:56:48 +0900 (JST)
Message-ID: <5490F0DB.5020309@jp.fujitsu.com>
Date: Wed, 17 Dec 2014 11:56:27 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Joe Doliner <jdoliner@pachyderm.io>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: finding path of subvolume from uuid
References: <CAA2X+Rn0LgVEcovYLGvu_kjHBqc7qQgXgEAQ7mKs6MORmeop4A@mail.gmail.com>
In-Reply-To: <CAA2X+Rn0LgVEcovYLGvu_kjHBqc7qQgXgEAQ7mKs6MORmeop4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

(2014/12/16 18:52), Joe Doliner wrote:
> Using `btrfs subvolume show path` I can get information about what a
> subvolume's parent is by uuid.
> I'd like to use that information to perform a find-new between the
> subvolume and its parent. To do that though I need the path of the
> parent and I'm not sure the best way to do find it.

I couldn't understand what the meaning of "a find new between
the subvolume and its parent." Could you explain it more clearly?

>
> One way would be to grep a `btrfs subvolume list` which is probably
> fine but needlessly slow if there's a direct way to convert from uuid
> to path.
>
> Also just subscribed to this list, nice to meet all of you I'm jdoliner.

Nice to meet you too :-D

Thanks,
Satoru

>
> Thanks in advance for the help.
>
>
> Likely irrelevant but here's system config:
>
> Linux jd.c.celtic-guru-651.internal 3.17.2+ #2 SMP Thu Dec 4 18:08:02
> UTC 2014 x86_64 Intel(R) Xeon(R) CPU @ 2.60GHz GenuineIntel GNU/Linux
> Btrfs v3.14_pre20140414
> Label: 'ROOT'  uuid: 4c2a047c-c81f-4838-b281-0e562fe02afe
>          Total devices 1 FS bytes used 3.43GiB
>          devid    1 size 6.68GiB used 4.82GiB path /dev/sda9
>
> Label: none  uuid: 25db08a6-4771-48b6-bcae-999a65f49bf1
>          Total devices 1 FS bytes used 24.56GiB
>          devid    1 size 100.00GiB used 27.04GiB path /dev/sdb
>
> Label: none  uuid: dc6cd8a9-ff7e-4577-9098-3909061be47c
>          Total devices 1 FS bytes used 379.74MiB
>          devid    1 size 10.00GiB used 3.04GiB path /dev/loop0
>
> Btrfs v3.14_pre20140414
> Data, single: total=24.01GiB, used=23.70GiB
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=1.50GiB, used=880.41MiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=304.00MiB, used=0.00
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

