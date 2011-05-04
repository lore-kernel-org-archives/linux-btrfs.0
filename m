From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs csum failed
Date: Wed, 4 May 2011 09:18:40 +0700
Message-ID: <BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>
References: <4DC07A10.7070200@mur.at>
	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>
	<4DC0A153.3080806@mur.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Martin Schitter <ms@mur.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC0A153.3080806@mur.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2011 at 7:44 AM, Martin Schitter <ms@mur.at> wrote:
> Am 2011-05-04 02:28, schrieb Josef Bacik:
>>
>> Wait why are you running with btrfs in production?
>
> do you know a better alternative for continuous snapshots? :)

zfs :D

>
> it works surprisingly well since more than a year.
> well the performance could be better for vm-image-hosting but it works.
>
> we used cache='writeback' for a long time but now all virtual instances have
> set cache='none'
>
>> What OS is in this vm image?
>
> 2.6.30-bpo.1-amd64 with virtio-driver
>
> could you give me some advice how to debug/report this specific problem more
> precise?

If it's not reproducible then I'd suspect it'd be hard to do.

Usually checksum errors is early sign of hardware failure (most common
are disk or power supply).

-- 
Fajar
