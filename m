Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34612 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbcFPW4O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 18:56:14 -0400
Received: by mail-oi0-f47.google.com with SMTP id d132so92472549oig.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jun 2016 15:56:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9QOu=yjjPtq0DMDF_JG3qsjs4pJjCzHhrRDwx8QPkDT_xxaA@mail.gmail.com>
References: <CAK9QOun4rHcd6om7ZXaiv=ZGMCSufcZTJAFs2Sop=vBhcnxHJQ@mail.gmail.com>
	<CAK9QOu=yjjPtq0DMDF_JG3qsjs4pJjCzHhrRDwx8QPkDT_xxaA@mail.gmail.com>
Date: Thu, 16 Jun 2016 16:56:13 -0600
Message-ID: <CAJCQCtSepE+ze8vMqNYbO9jOzR1yJzFXPWVSXis=41ud0srD=A@mail.gmail.com>
Subject: Re: BTRFS, remarkable problem: filesystem turns to read-only caused
 by firefox download
From: Chris Murphy <lists@colorremedies.com>
To: Paul Verreth <paul@verreth.be>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2016 at 12:29 AM, Paul Verreth <paul@verreth.be> wrote:
> Dear all.
>
> When I download a video using  Firefox DownloadHelper addon, the
> filesystem suddenly turns read only. Not a coincedence, I tried it
> several times, and it happened every time again
>
> Info:
> Linux wolfgang 4.2.0-35-generic #40-Ubuntu SMP Tue Mar 15 22:15:45 UTC
> 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs --version
> btrfs-progs v4.0

I'm curious what you get from btrfs check (without --repair) with a
recent btrfs-progs, i.e. ideally a 4.5 version.

Fedora 24 is a go as of today, and the smallest image with btrfs-progs
4.5.2 on it is this 438M image:

http://dl.fedoraproject.org/pub/alt/stage/24_RC-1.2/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-24-1.2.iso

dd that to a USB stick and boot, at the boot menu pick
Troubleshooting, then pick Rescue a Fedora system. At the menu pick
skip to shell. Here you can run:

lsblk
btrfs check /dev/sdXY > btrfscheck.txt

That won't output 100% to that file but most of it will go there. If
you have a wired network connection it should be up already, otherwise
you're messing around with nmcli to get it up. scp it somewhere or if
the file is small enough you can 'fpaste btrfscheck.txt' and it'll
spit back a URL where it uploaded that file.




-- 
Chris Murphy
