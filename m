Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36508 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbbG0TQl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 15:16:41 -0400
Received: by wicgb10 with SMTP id gb10so125921971wic.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 12:16:40 -0700 (PDT)
Received: from [10.0.2.15] (p4FCB7C6A.dip0.t-ipconnect.de. [79.203.124.106])
        by smtp.googlemail.com with ESMTPSA id l2sm15105291wib.11.2015.07.27.12.16.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2015 12:16:39 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: =?UTF-8?Q?Re:_systemd_:_Timed_out_waiting_for_defice_dev-disk-by?=
 =?UTF-8?B?4oCm?=
To: linux-btrfs@vger.kernel.org
References: <1437763277.673610371@apps.rackspace.com>
 <55B54568.5060902@googlemail.com>
 <pan$a902b$10dd7fbd$f0ca0693$dc0cc8e3@cox.net>
Message-ID: <55B68396.1030505@googlemail.com>
Date: Mon, 27 Jul 2015 21:16:38 +0200
MIME-Version: 1.0
In-Reply-To: <pan$a902b$10dd7fbd$f0ca0693$dc0cc8e3@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/27/2015 07:20 AM, Duncan wrote:
> Philip Seeger posted on Sun, 26 Jul 2015 22:39:04 +0200 as excerpted:
>
>> Hi,
>>
>>> 50% of the time when booting, the system go in safe mode because my 12x
>>> 4TB RAID10 btrfs is taking too long to mount from fstab.
>>
>> This won't help, but I've seen this exact behavior too (some time ago).
>> Except that it wasn't 50% that it didn't work, more like almost
>> everytime.
>> Commenting out the fstab entry "fixed" it, mounting using a cronjob
>> (@reboot) worked without a problem.
>>
>> (As far as I remember, options like x-systemd.device-timeout didn't
>> change anything.)
>>
>> If someone has the answer, I'd be interested too.
>
> You mean something like a custom systemd *.service unit file?  That's
> what I'd do here. =:^)
> [...]

Thanks for the tip and the detailed explanation. I believe I have tried 
something similar back then (involving a custom systemd service), but 
it's too long ago, I can't tell for sure. What I do remember clearly is 
that the timeout error came within seconds after invoking the mount 
command, maybe 5 or 10 seconds - certainly not even close to 30 seconds. 
Just wanted to throw that out there.

Other than that, I believe using the noauto option together with a 
custom systemd service sounds like it should do the trick (and sounds 
like a clean solution if you indeed want that filesystem mounted on 
demand only), but then again, mounting a filesystem without that option 
should work too. In any case, I've saved your email, maybe I'll hit that 
issue again someday - I'll try your suggestion then.


Philip
