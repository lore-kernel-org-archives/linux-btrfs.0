Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from icts.hu ([195.70.57.6]:59852 "EHLO icts.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbcELSeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 14:34:03 -0400
Received: from [192.168.152.152] (84-236-90-99.pool.digikabel.hu [84.236.90.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by icts.hu (Postfix) with ESMTPSA id CFCFE36B838
	for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 20:28:24 +0200 (CEST)
From: =?UTF-8?B?U3phbG1hIEzDoXN6bMOz?= <dblaci@dblaci.hu>
Subject: Re: Input/output error on newly created file
To: linux-btrfs@vger.kernel.org
References: <8760uoqjlt.fsf@vostro.rath.org> <878tzilhf3.fsf@vostro.rath.org>
 <87eg971dqf.fsf@thinkpad.rath.org> <58549996.M9MX6vESn9@archlinux>
 <8760uj18d6.fsf@thinkpad.rath.org>
Message-ID: <ade418fb-d741-54d0-c9c2-1018889edc72@dblaci.hu>
Date: Thu, 12 May 2016 20:28:24 +0200
MIME-Version: 1.0
In-Reply-To: <8760uj18d6.fsf@thinkpad.rath.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-05-12 19:41 keltezéssel, Nikolaus Rath írta:
> On May 12 2016, Diego Calleja <diegocg@gmail.com> wrote:
>> El jueves, 12 de mayo de 2016 8:46:00 (CEST) Nikolaus Rath escribió:
>>> *ping*
>>>
>>> Anyone any idea?
>> All I can say is that I've had the same problem in the past. In my
>> case, the problematic files where active torrents. The interesting
>> thing is that I was able to read them correctly up to a point, then
>> I would get the same error as you. No messages in dmesg. The amount
>> of data I was able to read from them was not random, it was
>> something multiple of 4K. After reboot the problems went away and
>> I wasn't able to reproduce it.
>>
>> There has been reports of similiar issues in the past:
>> http://www.spinics.net/lists/linux-btrfs/msg52371.html
> Thanks for the pointer. So according to these reports, the IO errors
> happen with:
>
>
> 1. dm-crypt, LVM and mount options
>     rw,noatime,compress=lzo,ssd,discard,space_cache,autodefrag,inode_cache
> 2. dm-crypt, no LVM, and mount options
>     noatime,compress,nossd
>
> I can add the following data point:
>
> 3. dm-crypt on LVM, and mount options
>     relatime,compress=lzo
>
>
> (Just to preserve this for the future)

I don't want to repeat my e-mails in the past, but I think I have a 
similar issue. In short: xen virtual machine. The files that rarely 
become unreadable (I/O error but no error in dmesg or anywhere) are 
mysql MyIsam database files, and they are always small. Like 16kbyte for 
example, or smaller. Sometimes dropping the fs cache fixes the problem, 
sometimes not. Umount / mount always fixes the problem. Scrub says the 
filesystem is OK (when the file is unreadable).

I experienced similar problem with log files (smtp or apache log files), 
but it is rare. It happens 1-2 times in a month on a heavy loaded 
mail/web server. (the log file io error is not a real problem for me, 
mysql is.). The problem present from 3.18 to 4.5.

I started to migrate mysql table files to innodb, but i think this is 
only a workaround.

László Szalma


>
>
> Best,
> -Nikolaus


