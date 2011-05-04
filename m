From: Kaspar Schleiser <kaspar@schleiser.de>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 14:31:50 +0200
Message-ID: <4DC14736.7010603@schleiser.de>
References: <4DC07A10.7070200@mur.at>	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>	<4DC0A153.3080806@mur.at> <BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com> <4DC13B02.9030604@mur.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC13B02.9030604@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

Hey Martin,

On 05/04/11 13:39, Martin Schitter wrote:
>> Usually checksum errors is early sign of hardware failure (most
>> common are disk or power supply).
>
> that looks very unplausible to me. there is an RAID1 layer beneath btrfs
> in our setup and i don't see any errors there.
Is the btrfs RAID1 itself inside a virtual machine? I've had data 
corruption with virtio block devices > 1TB on early squeeze kernels.

Kaspar
