From: Martin Schitter <ms@mur.at>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 02:44:03 +0200
Message-ID: <4DC0A153.3080806@mur.at>
References: <4DC07A10.7070200@mur.at> <20110504002815.GA27861@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110504002815.GA27861@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 2011-05-04 02:28, schrieb Josef Bacik:
> Wait why are you running with btrfs in production?

do you know a better alternative for continuous snapshots? :)

it works surprisingly well since more than a year.
well the performance could be better for vm-image-hosting but it works.

we used cache='writeback' for a long time but now all virtual instances 
have set cache='none'

> What OS is in this vm image?

2.6.30-bpo.1-amd64 with virtio-driver

could you give me some advice how to debug/report this specific problem 
more precise?

thanks
martin
