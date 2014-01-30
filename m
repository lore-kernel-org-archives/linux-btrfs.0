Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37187 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752809AbaA3TcN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 14:32:13 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CABgvyo9FYGSYpj+jL1oqCvtNUqsC8HZ+z=x-Gz7naWoEcCKWpQ@mail.gmail.com>
Date: Thu, 30 Jan 2014 12:32:11 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <492C3046-23E0-4583-8790-CE5A7C49901D@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com> <7D962F82-BAB8-48E5-8B4D-3CDBFD10D9C5@colorremedies.com> <CABgvyo9FYGSYpj+jL1oqCvtNUqsC8HZ+z=x-Gz7naWoEcCKWpQ@mail.gmail.com>
To: =?iso-8859-1?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2014, at 11:44 AM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:

> 2014-01-30 Chris Murphy <lists@colorremedies.com>:
>> Is this encrypted Btrfs volume used for rootfs? Or is it only for data?  If it's only for data, then make sure the volume (all subvolumes) are umounted, then mount with this:
>> 
>> -o degraded,recovery,skip_balance
>> 
>> Do you still get too many missing devices message?
> 
> root@fortknox:/# mount  -odegraded,recovery,skip_balance
> /dev/mapper/bunkerA /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/bunkerA,
>       missing codepage or helper program, or other error
>       In some cases useful info is found in syslog - try
>       dmesg | tail  or so
> 
> root@fortknox:/# dmesg|tail
> [781630.598155] btrfs: bdev (null) errs: wr 1375454, rd 186442, flush
> 0, corrupt 0, gen 0


That's a lot of read and write errors. I wonder what that's all about. Is btrfs tracking the resulting read/write failures due to the missing device?

So at this point it's worth a btrfs check /dev/mapper/bunkerA. This is read only, does not make repairs. And also I'm curious what you get for btrfs-show-super -a /dev/mapper/bunkerA. The volume shouldn't be mounted for the first one, and can be either mounted or not for the 2nd.


Chris Murphy

