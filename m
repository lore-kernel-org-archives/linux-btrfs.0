Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43600 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750928AbaAOEGD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 23:06:03 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:56050 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3Hju-002nFD-Cs
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 21:06:02 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck failes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAFP7zVtDEfDjKA1GvBq_QMs6gKv9t=K_qNyv6dcxawe5iuj8Kw@mail.gmail.com>
Date: Tue, 14 Jan 2014 21:06:00 -0700
Message-Id: <D942F4C1-471E-476F-BEC1-3090DDAEB115@colorremedies.com>
References: <CAFP7zVtDEfDjKA1GvBq_QMs6gKv9t=K_qNyv6dcxawe5iuj8Kw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2014, at 4:24 PM, Holger Brandsmeier <brandsmeier@gmail.com> wrote:

> Dear Chris,
> 
> as requested:
> 
> # btrfs fi show
> Label: none  uuid: 267f069c-11da-4d2a-88fa-00cab4e28149
>        Total devices 1 FS bytes used 12.68GiB
>        devid    1 size 29.82GiB used 24.27GiB path /dev/sdb1
> Label: none  uuid: f6907d81-f46f-4911-8600-858e8b6bd1a0
>        Total devices 1 FS bytes used 141.72GiB
>        devid    1 size 278.00GiB used 212.04GiB path /dev/sda5
> Btrfs v3.12
> 
> The problem makes `/dev/sda5`. I attached the output of `smartctl -x /dev/sda5`.

There are some reallocated sectors. dmesg reports 
[ 2023.770828] btrfs read error corrected: ino 1 off 605564928 (dev /dev/sda5 sector 1199128)

That might be metadata on a bad sector that was fixed from duplicate metadata. This is single device Btrfs with default DUP metadata?

> 
> # mount -o clear_cache /dev/sda5 data/
> mount: wrong fs type, bad option, bad superblock on /dev/sda5,
>       missing codepage or helper program, or other error
> 

Hmm. So maybe the 1st superblock is no good. But it might be worth trying btrfs-zero-log first. It's possible the repair made this worse.

https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27613.html



Chris Murphy

