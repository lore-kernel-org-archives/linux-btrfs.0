Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.bordeaux.inra.fr ([147.100.111.220]:28576 "EHLO
	mail-1.bordeaux.inra.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755927AbaIRNmL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 09:42:11 -0400
Received: from [147.100.98.136] ([147.100.98.136])
	(authenticated bits=0)
	by mail-1.bordeaux.inra.fr (/8.14.4) with ESMTP id s8IDln4m003297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 15:47:50 +0200 (CEST)
Message-ID: <541AE130.3070200@bordeaux.inra.fr>
Date: Thu, 18 Sep 2014 15:42:08 +0200
From: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Problem with a filesystem
References: <54185D48.5060701@bordeaux.inra.fr> <4F2E9AE1-4B33-42BB-8B75-C5A66118A7CB@colorremedies.com> <5418995C.2000708@bordeaux.inra.fr> <82857E4F-9FF6-4110-993F-35830A44BC04@colorremedies.com> <54194F07.2080203@bordeaux.inra.fr> <800A0C28-B668-4510-850E-DC92E67AD878@colorremedies.com>
In-Reply-To: <800A0C28-B668-4510-850E-DC92E67AD878@colorremedies.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/17/2014 08:49 PM, Chris Murphy wrote:
> 
> This isn't what I expect as a candidate for btrfs-zero-log, I don't know what the last message means. You could run a 
> btrfs check <btrfsdev>
> and then ask about both the failure to read block groups -5 and also the btrfs check (without --repair) results
> 
> Or take a leap of faith, take an image of the file system first as it might make recovery more difficult. If there are things you really need off this file system first you should look at https://btrfs.wiki.kernel.org/index.php/Restore before zeroing the log.
> 
> btrfs-image -c 9 -t 8 <btrfsdev> /path/to/file
> btrfs-zero-log <btrfsdev>
> 
> 
> Chris Murphy
Well,
btrfs check ends also with a failed message.
In any ways, I think this FS corruption is due to a weakness of my raid
card. Indeed, before it happens, the kernel panicked because of this
card. The card claims that he had lost 2 disks from the pool but, just
removing them and plugging them again solved the error.
My thinking is that I didn't plug the two disks on the proper sequence.
So it corrupted the raid reconstruction process.
By the way, I don't have enough structure to host 26TB of an image.
Moreover, as it is our backup server, we need it to get back as soon as
possible.
What I'm gonna do, now, is to make a new file system instead and set up
everything one more time.
Thank you so much for helping me.

Tovo
