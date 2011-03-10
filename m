From: Alexey A Nikitin <moonwalker@syrius.us>
Subject: Re: BTRFS fsck tool
Date: Thu, 10 Mar 2011 11:30:54 -0600
Message-ID: <AANLkTimK8LD50ga=uJuJYJ84Y37KoZPRieGmDHt6HncG@mail.gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
 <4D7591CC.6060301@shiftmail.org> <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com>
 <20110308065255.24100.qmail@stuge.se> <1299762048-sup-3940@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Peter Stuge <peter@stuge.se>, Spelic <spelic@shiftmail.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299762048-sup-3940@think>
List-ID: <linux-btrfs.vger.kernel.org>

2011/3/10 Chris Mason <chris.mason@oracle.com>
>
> Which kernel were you on? =C2=A0Was btrfs directly accessing the disk=
s or
> were things like LVM in use?
> Recent kernels (.37 and higher) have improved support for barriers in
> LVM and friends, but btrfs directly using the disks should have been
> safe for a long time.

Now that's funny. I'm using  2.6.32-5-amd64 from Debian Wheezy and
while btrfs on top of LVM works perfectly stable I have now trouble
with FS that is directly on partition. Does it make difference
stability-wise if partition table on disk is GPT rather than
old-school MS-DOS? Because all my disks, LVM and non-LVM, are set with
GPT.

Best,

Alexey

--
This message was created with 100% recycled electrons
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
