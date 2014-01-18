Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37663 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaARBac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 20:30:32 -0500
Received: by mail-wi0-f172.google.com with SMTP id ex4so1437525wid.17
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 17:30:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389983615.90027.YahooMailNeo@web172606.mail.ir2.yahoo.com>
References: <1389983615.90027.YahooMailNeo@web172606.mail.ir2.yahoo.com>
Date: Sat, 18 Jan 2014 08:30:31 +0700
Message-ID: <CAG1y0sd1s2MxpXrN1DoqWtkBn50jE3CP1DoW4WT06sJuzu=Rjw@mail.gmail.com>
Subject: Re: drawbacks of non-ECC RAM
From: "Fajar A. Nugraha" <list@fajar.net>
To: "valleysmail-lol5@yahoo.de" <valleysmail-lol5@yahoo.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 18, 2014 at 1:33 AM, valleysmail-lol5@yahoo.de
<valleysmail-lol5@yahoo.de> wrote:
>
>
>
> I'd like to know if there are drawbacks in using btrfs with non-ECC RAM instead of using ext4 with non-ECC RAM.

Non-ECC RAM can cause problems no matter what fs you use.

> I know that some features of btrfs may rely on ECC RAM but is the chance of data corruption or even a damaged filesystem higher than when i use ext4 instead of btrfs?

Not really.

In the past the occurence of corrupted btrfs report on this list
(regardless of RAM) is somewhat high, but I don't see much of it in
recent versions.

> I want to know this because i would like to use the snapshot feature of btrfs and ext4 does not support that. I will not use btrfs for fixing silent data corruption nor for using RAID like features or encryption. ZFS however checks files in the background (even if i don't want)

zfs does not "checks files in the background" by default. When
checksum is enabled (the default option), zfs only checks file
integrity when you access it, and when you run the "scrub" command. It
does not run background scrubs automatically.

AFAIK btrfs behaves the same way.

> and if it thinks there is an error it will fix it and i cannot disable this feature. So errors in RAM may corrupt my files or even more.

You can disable checksum on both btrfs and zfs. See
https://btrfs.wiki.kernel.org/index.php/FAQ#Can_data_checksumming_be_turned_off.3F
,  https://btrfs.wiki.kernel.org/index.php/Mount_options

-- 
Fajar
