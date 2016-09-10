Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.moparisthebest.com ([144.76.72.168]:35244 "EHLO
        mailer.moparisthebest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbcIJSuK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 14:50:10 -0400
Subject: Re: btrfs kernel oops on mount
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
 <CAJCQCtQpfJ9eji_KrNMsRkgEP=psL_PQc+nsPNJY8qAYey60VA@mail.gmail.com>
From: moparisthebest <admin@moparisthebest.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <57D455DB.20505@moparisthebest.com>
Date: Sat, 10 Sep 2016 14:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQpfJ9eji_KrNMsRkgEP=psL_PQc+nsPNJY8qAYey60VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2016 03:28 PM, Chris Murphy wrote:
> Sounds like with enospc devs want to see a couple things beyond what I
> asked for:
> 
> enospc_debug
> grep -IR . /sys/fs/btrfs/UUID/allocation/
> 
> That's kinda hard to do right now if it's not mounting though...

I managed to get more output from arch/4.7.2 using netconsole, I did end
up with duplicate lines somehow though which uniq fixed, but some of the
crash is mixed together on the same line, I didn't mess with that for
fear of taking out something important:

https://www.moparisthebest.com/btrfs/archnetconsole.txt

I was also able to mount it ro so I ran the grep you asked for:

https://www.moparisthebest.com/btrfs/enospcdebug.txt

I tried mounting with mount -o rw,skip_balance and it still locked up,
so for now it's read-only...

Let me know what else I can provide or try.  I haven't been able to boot
with a 4.7 kernel on my ubuntu install so I figure 4.8 will be the same,
I guess I'll need to permanently install something like arch to a flash
drive and try 4.8 from there.

Thanks!

