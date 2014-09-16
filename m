Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc1s6.hotmail.com ([65.54.190.17]:60200 "EHLO
	BAY004-OMC1S6.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaIPUPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 16:15:12 -0400
Message-ID: <BAY172-W49807D9D79231B7B004F04B0C90@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs balance enospc
Date: Tue, 16 Sep 2014 15:10:04 -0500
In-Reply-To: <5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com>
References: <54186A4B.60902@intellasoft.net>
 <54186A82.7070801@intellasoft.net>,<5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> From: lists@colorremedies.com
> Date: Tue, 16 Sep 2014 11:26:16 -0600
>
>
> On Sep 16, 2014, at 10:51 AM, Mark Murawski <markm-lists@intellasoft.net> wrote:
>
>>
>> Playing around with this filesystem I hot-removed a device from the
>> array and put in a replacement.
>>
>> Label: 'Root' uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>> Total devices 2 FS bytes used 7.43GiB
>> devid 1 size 9.31GiB used 8.90GiB path /dev/sdc6
>> devid 3 size 9.31GiB used 8.90GiB path
>> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
>>
>> <removed /dev/sdc>
>>
>> Label: 'Root' uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>> Total devices 2 FS bytes used 7.43GiB
>> devid 3 size 9.31GiB used 8.90GiB path
>> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
>> *** Some devices missing
>>
>> cartman {~} root# btrfs device add /dev/sdi6 /
>> cartman {~} root# btrfs fi show
>> Label: 'Root' uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>> Total devices 3 FS bytes used 7.43GiB
>> devid 3 size 9.31GiB used 8.90GiB path
>> /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
>> devid 4 size 10.00GiB used 0.00 path /dev/sdi6
>> *** Some devices missing
>>
>> cartman {~} root# btrfs filesystem balance start /
>
> Better to use btrfs replace. But sequence wise you should do btrfs device delete missing, which should then effectively do a balance to the newly added device. So while the sequence isn't really correct, that's probably not why you're getting this failure.

Does/should a balance imply removal of missing devices (as long as the minimum number of devices are still available)?

>
>>
>>
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2411,
>> rd 0, flush 38, corrupt 137167, gen 25
>
> Please post results of
> smartctl -x /dev/sdc
>
>
>
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2412,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2413,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2414,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2415,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2416,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2417,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2418,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2419,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:12 localhost kernel: BTRFS: bdev /dev/sdc6 errs: wr 2420,
>> rd 0, flush 38, corrupt 137167, gen 25
>> Sep 16 12:47:14 localhost kernel: BTRFS: lost page write due to I/O
>> error on /dev/sdc6
>> Sep 16 12:47:14 localhost kernel: BTRFS: lost page write due to I/O
>> error on /dev/sdc6
>
> I'd expect with Btrfs having problems writing to a device, that there'd be libata messages related to this also. Do you have earlier kernel messages indicating the drive or controller are reporting errors?
>

 		 	   		  