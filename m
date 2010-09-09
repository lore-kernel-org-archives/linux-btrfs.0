From: Marcel Lohmann <marcel.lohmann@googlemail.com>
Subject: Re: btrfs on LVM: Out of space
Date: Thu, 9 Sep 2010 12:54:52 +0200
Message-ID: <AANLkTik1cXM0uwhwJSFNKMT1aiyRRLvNhYNFUGw8-zvt@mail.gmail.com>
References: <AANLkTinyfVH7DkOTNW-iSJjKExh5eS9Ea-HX0TY+XJ7b@mail.gmail.com>
	<AANLkTimLFf-GezTk07NCQjNKkB5RyVge81kzhs27=jAb@mail.gmail.com>
	<AANLkTini5k0cOwCW5WrZuw3M0ynDy8v9MbSyzPGMRmZy@mail.gmail.com>
	<AANLkTim2y=nV7eeKBGKJ1ynz1OTwo-q6BtF+BuEvX0c=@mail.gmail.com>
	<AANLkTikujoMMHiwhgBns7W462pPYSsTywY6uHCw2vUCD@mail.gmail.com>
	<AANLkTi=EyKFr_QCAoWtM=wZ8EnijcDuDfjgiyaE+dnuc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=EyKFr_QCAoWtM=wZ8EnijcDuDfjgiyaE+dnuc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/9/9 Zhu Yanhai <zhu.yanhai@gmail.com>:
> 200B ~ 2000B is really too small to the modern hard disks (some of them
> already have 4KB-sectors instead of 512B).

I know. But I thought that btrfs is the best FS for handling that.
Besides other storage methods than keeping small files on a
filesystem.
This is why I wanted to give it a try. It's currently just an
experiment for me to evaluate best practices.

> Besides, currectly Btrfs doesn't play quite well with such small files, you may

> had a patch for it, IIRC. Here it is:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05292.html
> I don't know whether it has been in the kernel you are using.

Looking real quick on the patch and the git commits I would confirm
that this is already in the kernel 2.6.35 (which Ubuntu 10.10 uses).
So there is a good chance to have a "repaired" filesystem when I
recreate it.

Marcel
