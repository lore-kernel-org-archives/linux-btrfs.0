Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44337 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3AaJpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 04:45:23 -0500
Received: by mail-ee0-f41.google.com with SMTP id c13so1318806eek.14
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 01:45:21 -0800 (PST)
Message-ID: <510A3D1D.4010501@statystyka.net>
Date: Thu, 31 Jan 2013 10:45:01 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: andrew.j.wade@gmail.com, linux-btrfs@vger.kernel.org
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping
 process which writes a lot
References: <CAAuLxcbVXFjzvZ+Oj4MUEHnsOhhbVPTeKx-34En2ym37J2wuuA@mail.gmail.com>
In-Reply-To: <CAAuLxcbVXFjzvZ+Oj4MUEHnsOhhbVPTeKx-34En2ym37J2wuuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-01-31 04:33, Andrew Wade wrote:
> Hi Adam,
>
> Is btrfs mounted relatime? I'm wondering if you're seeing metadata
> writes from atime updates. I've got my filesystem mounted noatime to
> avoid breaking metadata sharing between subvolumes.
>
> Apologies for the broken threading - I'm not subscribed to the list.
>
> regards,
> Andrew

Thank you, thank you!!! Hurray!! That was the problem!! I'm so happy 
you've helped me out!!!

After mounting the system with noatime the problem disappeared, like in 
magic.

All the writes must have came from the dealyed metadata copy process. 
Once all the metadata copy-update was done, file system speed was back 
to normal, but once the new day broke out, all the copying business 
needed to done again... This in 100% describes all the odd behavior.

In particular apparently the problem had nothing to do with my complex 
block device setup, nor with bedup, nor with unison.

Thank you again, Andrew!

P.S. Maybe it is not be decided by me, but this small message about 
performance (not even labeled as warning) in 
https://btrfs.wiki.kernel.org/index.php/Mount_options IMHO should have 
been made more conspicuous, maybe put somewhere when the snapshot 
mechanism is described or in FAQ. I'll try to fix it.

-- 

Adam Ryczkowski
+48505919892 <callto:+48505919892>
Skype:sisteczko <skype:sisteczko>

