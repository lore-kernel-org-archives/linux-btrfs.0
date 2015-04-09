Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33626 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbbDITtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 15:49:23 -0400
Received: by iebmp1 with SMTP id mp1so1043620ieb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 12:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5526A2D0.2030103@lianse.eu>
References: <5526A2D0.2030103@lianse.eu>
Date: Thu, 9 Apr 2015 13:49:23 -0600
Message-ID: <CAJCQCtS24gzNgOuUgea5_eT-7UDP4fDNMGAxfR5fcy6btK2FQw@mail.gmail.com>
Subject: Re: btrfs filesystem resize <ID>:max not working
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Andr=C3=A9=2DSebastian_Liebe?= <andre@lianse.eu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 9, 2015 at 10:03 AM, André-Sebastian Liebe <andre@lianse.eu> wrote:
> Hey list,
>
> I've got a problem with resizing a multi drive filesystem.
> I had a 5 disk array of 4TB drives. Then I added a 5th (6TB) drive to
> the array and replaced one of the 4TB ones with a 6TB drive.

You did device add, device delete, then fi resize? It should work but
it's better to use btrfs replace start for this sort of operation
since it does all of that in one step.

> As you can
> see in my `btrfs fi sh` output below, my newly added drive (ID=6) has
> the expected size of 5.46TiB, but my replaced drive (ID=4) won't show up
> as 6TB as expected. Neither a `btrfs fi res max /data/pool0` nor a
> `btrfs fi res 4:max /data/pool0` had any effect.
>
> Any suggestions how to reclaim the 2TB free space of drive 4?

Not sure, this has always worked for me in the past, online. You could
try unmounting and doing a btrfs dev scan, remounting, and then
retrying the command. There's nothing in dmesg? There should be
something there whether it succeeds or fails.


-- 
Chris Murphy
