Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.70.57.6] ([195.70.57.6]:59492 "EHLO icts.hu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbbKBS1C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 13:27:02 -0500
Received: from [192.168.152.152] (78-131-16-36.pool.digikabel.hu [78.131.16.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by icts.hu (Postfix) with ESMTPSA id 4E0731D8313E
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2015 19:26:01 +0100 (CET)
Subject: Re: random i/o error without error in dmesg
To: linux-btrfs@vger.kernel.org
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
 <pan$69543$b4766f34$8286648d$3871cb8f@cox.net> <56308ADC.5060207@dblaci.hu>
From: =?UTF-8?B?U3phbG1hIEzDoXN6bMOz?= <dblaci@dblaci.hu>
Message-ID: <5637AAB9.5040901@dblaci.hu>
Date: Mon, 2 Nov 2015 19:26:01 +0100
MIME-Version: 1.0
In-Reply-To: <56308ADC.5060207@dblaci.hu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-10-28 09:44 keltezéssel, Szalma László írta:
> Ok, I had a chance to try some things.
>
> 1.: the error
>
> md5sum xyz
> md5sum: xyz: Input/output error
>
> (no any errors in dmesg)
>
> 2.: mount -o remount,ro /mnt/x
>
> (could not do, it is used)
> mysql stop && mount -o remount,ro /mnt/x
> problem persists: io error.
> mount -o remount,rw /mnt/x
> still io error
> umount /mnt/x
> mount /mnt/x
> NO io error, md5sum works!
>
> The umount/mount ALWAYS solved the problem for me, mount -o remount,ro 
> was tried for the first time, but it was not enought. Reboot was not 
> needed.
> (kernel 4.2.4)
>
> László Szalma
>

Unfortunately the problem with kernel 4.3.0 still exists.

László Szalma

