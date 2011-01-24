From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 10:41:36 +0100
Message-ID: <20110124094136.GB24477@scooter>
References: <20110123231536.GA2560@scooter>
 <BeTk1I7T1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BeTk1I7T1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Lol :)

You can't use labels for the decryption, because an encrypted device has no label, it
doesn't even have a filesystem and you can't say if there are any kind of data on it
(in my case) :)

You can use labels after you have decrypted the device. Then I'm using labels, too.
But that doesn't help with  this problem :)


Regards,
Felix


On 24. January 2011 - 08:42, Helmut Hullen wrote:
> Date:	24 Jan 2011 08:42:00 +0100
> From: Helmut Hullen <Hullen@t-online.de>
> To: linux-btrfs@vger.kernel.org
> Subject: Re: Bug in mkfs.btrfs?!
> 
> Hallo, Felix,
> 
> Du meintest am 24.01.11:
> 
> > Sorry that I didn't saw that earlier. If I would use /dev/sdxx
> > instead of /dev/disk/by-id/ for decrypting the devices it would be
> > working. But those ids didn't change if I remove/add a device, so it
> > would be nice to be able to use those ids.
> 
> I prefer working with LABELs. They can be short and self explaining.
> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
