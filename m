Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33236 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbbCWNWg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 09:22:36 -0400
Received: by ignm3 with SMTP id m3so32537914ign.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 06:22:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550FCD9C.1000706@oracle.com>
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
	<550FCD9C.1000706@oracle.com>
Date: Mon, 23 Mar 2015 09:22:36 -0400
Message-ID: <CAGfcS_miW0=6A7a5PAQZcseCbS1KDpTPM7woKTosMjnAB3C3Cw@mail.gmail.com>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 4:23 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
> Do you still have the problem ? Can you pls confirm on the latest btrfs ?
> Since I am fixing the devices part of the btrfs, I am bit nervous.

I'm having a similar problem.  I'm getting some kind of btrfs
corruption that causes a panic/reboot, and then the initramfs won't
mount root for 3.18.9, but it will mount it for 3.18.8.

Running on 3.18.8 eventually caused the panic to repeat, so I'm not
sure that 3.18.9 is necessarily breaking things - it might just be
fussier about not mounting a dirty fs.

I did run a btrfs check --repair and it ended up moving some chromium
preferences from the user profile folder to lost+found.  That got the
system to run for about 8 hours, but it still paniced the next
morning.  I'm now running on 3.18.7 to see what happens.

Unfortunately I haven't been doing a good job about capturing logs.
I'll try to capture more the next time this happens.  I've been
running fine on 3.18 for a while now, so I'm not sure where all of
this is coming from.

--
Rich
