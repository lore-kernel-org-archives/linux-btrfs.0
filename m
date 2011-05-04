From: Martin Schitter <ms@mur.at>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 15:25:42 +0200
Message-ID: <4DC153D6.3070301@mur.at>
References: <4DC07A10.7070200@mur.at>	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>	<4DC0A153.3080806@mur.at> <BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com> <4DC13B02.9030604@mur.at> <4DC14736.7010603@schleiser.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Kaspar Schleiser <kaspar@schleiser.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC14736.7010603@schleiser.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am 2011-05-04 14:31, schrieb Kaspar Schleiser:
> Is the btrfs RAID1 itself inside a virtual machine? I've had data
> corruption with virtio block devices > 1TB on early squeeze kernels.

no -- it's on the (native) host side. and we use a very actual kernel 
from debian 'testing' (2.6.38-2).

martin
