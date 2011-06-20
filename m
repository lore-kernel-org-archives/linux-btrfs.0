From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: compression ratio
Date: 20 Jun 2011 16:34:00 +0200
Message-ID: <BoFzq7Oi1uB@helmut.hullen.de>
References: <4DFF2F29.4040108@corp.mail.ru>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFF2F29.4040108@corp.mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Proskurin,

Du meintest am 20.06.11:

> I`m new to btrfs and do some testing now.

> What we have:
> SL6 - kernel 2.6.32-131.2.1.el6.x86_64
> mdadm RAID5 with 8 HDD - 27T partition.

You should take a newer kernel. On my system I needed 2.6.38.5 and newer  
for btrfs; older kernels lead to unreadable partitions.

Viele Gruesse!
Helmut
