From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: 'bad tree block start' mount failure...
Date: Tue, 20 Mar 2012 17:16:06 +0100
Message-ID: <CAK-xaQbAq85UFa41h-As3yDXvVz5ybtGU-ySVYJmcRLc0GgbgA@mail.gmail.com>
References: <CAMVG2suJw2miSP9QUi-ArFrzS0-okN0_MsLPZTc6Xv7xkjLHDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2suJw2miSP9QUi-ArFrzS0-okN0_MsLPZTc6Xv7xkjLHDw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/20 Daniel J Blueman <daniel@quora.org>:
> mkfs.btrfs -m raid0 -d raid0 /dev/sdb1 /dev/sdc1
> mount /dev/sdb1 /mnt
> umount /mnt
> mount /dev/sdb1 /mnt -o compress
> umount /mnt
> mount /dev/sdb1 /mnt -o ssd
> umount /mnt
> mount /dev/sdb1 /mnt -o discard
> umount /mnt
> mount /dev/sdb1 /mnt
> <mount failure>

Well, I can't reproduce this. It's also true that I use some
out-of-the-tree patches.
I wrote this each step. They must be in a script?

Ciao,
Gelma
