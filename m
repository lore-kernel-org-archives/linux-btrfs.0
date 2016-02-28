Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dragon.async.com.br ([208.70.149.241]:56497 "EHLO
	dragon.async.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbcB1UfD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 15:35:03 -0500
Received: from anthem.async.com.br (189-19-234-109.dsl.telesp.net.br [189.19.234.109])
	by dragon.async.com.br (Postfix) with ESMTPS id CE7E14540F8
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 14:35:00 -0600 (CST)
Received: from anthem.async.com.br (kiko@localhost [127.0.0.1])
	by anthem.async.com.br (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id u1SKYnWk032614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 17:34:50 -0300
Received: (from kiko@localhost)
	by anthem.async.com.br (8.14.4/8.14.4/Submit) id u1SKYmtw032609
	for linux-btrfs@vger.kernel.org; Sun, 28 Feb 2016 17:34:48 -0300
Date: Sun, 28 Feb 2016 17:34:48 -0300
From: Christian Robottom Reis <kiko@async.com.br>
To: linux-btrfs@vger.kernel.org
Subject: Re: Replacing RAID-1 devices with larger disks
Message-ID: <20160228203448.GA31674@anthem.async.com.br>
References: <20160228201532.GA26692@anthem.async.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160228201532.GA26692@anthem.async.com.br>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 28, 2016 at 05:15:32PM -0300, Christian Robottom Reis wrote:
> I've managed to do the actual swap using a series of btrfs replace
> commands with no special arguments, and the system is now live and
> booting from the 256GB drives. However, I haven't actually noticed any
> difference in btrfs fi show output, and usage looks weird. Has anyone
> seen this before or have a clue as to who?

Yes, now I do, about 10 minutes after writing that mail. After a btrfs
replace, if the device being added is larger than the original device,
you need to issue:

    btrfs fi resize <devid>:max <path>

to actually use that disk space. So for something like:

>     Label: 'root'  uuid: 670d1132-00dc-4511-a2f6-d28ce08b4d3a
>         Total devices 2 FS bytes used 9.33GiB
>         devid    1 size 13.97GiB used 11.78GiB path /dev/sda1
>         devid    2 size 13.97GiB used 11.78GiB path /dev/sdb1
> 
>     Label: 'var'  uuid: 815b3280-e90f-483a-b244-1d2dfe9b6e67
>         Total devices 2 FS bytes used 56.14GiB
>         devid    1 size 80.00GiB used 80.00GiB path /dev/sda3
>         devid    2 size 80.00GiB used 80.00GiB path /dev/sdb3

You need to do:

    btrfs fi resize 1:max /
    btrfs fi resize 2:max /

    btrfs fi resize 1:max /var
    btrfs fi resize 2:max /var

And it looks great now:

    Label: 'root'  uuid: 670d1132-00dc-4511-a2f6-d28ce08b4d3a
        Total devices 2 FS bytes used 9.34GiB
        devid    1 size 40.00GiB used 10.78GiB path /dev/sda1
        devid    2 size 40.00GiB used 10.78GiB path /dev/sdb1

    Label: 'var'  uuid: 815b3280-e90f-483a-b244-1d2dfe9b6e67
        Total devices 2 FS bytes used 56.16GiB
        devid    1 size 160.00GiB used 80.00GiB path /dev/sda3
        devid    2 size 160.00GiB used 80.00GiB path /dev/sdb3

This would be nice to document in the manpage for replace; it would also
be a good addition to the best google hit for replace RAID-1:

    http://unix.stackexchange.com/questions/227560/how-to-replace-a-device-in-btrfs-raid-1-filesystem

but I don't have enough reputation to do it myself.
-- 
Christian Robottom Reis | [+55 16] 3376 0125   | http://async.com.br/~kiko
                        | [+55 16] 991 126 430 | http://launchpad.net/~kiko
