From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Find RAID level, Change RAID level.
Date: Sun, 30 Oct 2011 16:06:17 +0200
Message-ID: <20111030140617.GA7012@zambezi.lan>
References: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
 <Bwm7ykHD1uB@helmut.hullen.de>
 <CACCfv7onURQQGGtY63kcirrxFtW4w-K8x0uqb_TPExoJc96row@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: helmut@hullen.de, linux-btrfs@vger.kernel.org
To: Jordan Windsor <jordanw2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7onURQQGGtY63kcirrxFtW4w-K8x0uqb_TPExoJc96row@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2011 at 12:10:34AM +1030, Jordan Windsor wrote:
> Thanks, It currently shows this:
> 
> Data: total=195.01GB, used=193.93GB
> System, DUP: total=8.00MB, used=28.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.75GB, used=385.41MB
> Metadata: total=8.00MB, used=0.00
> 
> I didn't specify any RAID levels during creation. I'd like to have a
> RAID0 installation across two hard drives.

How many devices do you have in your FS right now ?  If it's only 1 then
add another one (btrfs device add <dev> <path to FS>) and run balance
(btrfs fi balance <path to FS>).  That should give you raid0 for data
across two drives w/o applying any patches.

Thanks,

		Ilya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
