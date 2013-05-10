Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:27867 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3EJH1T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 03:27:19 -0400
Message-ID: <518CA154.20603@gmx.net>
Date: Fri, 10 May 2013 09:27:16 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Remco Hosman - Yerf IT <remco@yerf-it.nl>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: `btrfs receive` almost coming to a halt
References: <01E9FDE0-15C1-429C-AE54-B3A6CAFD7C3B@yerf-it.nl>
In-Reply-To: <01E9FDE0-15C1-429C-AE54-B3A6CAFD7C3B@yerf-it.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09.05.2013 17:14, Remco Hosman - Yerf IT wrote:
> kernel: 3.9.0
> btrfs-progs: pulled from git this morning
> 
> Trying to receive a 5gig send file. the first bit is fast, doing 10 - 50MB/sec.
> then it slows down. cpu usage is 50% (dual core machine).
> when i do a strace, it looks like this, repeating over an over, about 1 piece each second:
> --
> read(3, "q\0\0\0\20\0008\352\327o", 10) = 10
> read(3, "\22\0\10\0\0\0$~\0\0\0\0\30\0\10\0\0\0\2\0\0\0\0\0\17\0\24\0DB2/"..., 113) = 113
> open("/media/snaps/yerf-2013-05-02-03:15:01/DB2/DB2-flat.vmdk", O_RDONLY|O_NOATIME) = 6
> ioctl(5, 0x4020940d, 0x7fffc6d41c60)    = 0
> close(6)                                = 0
> read(3, "q\0\0\0\20\0\242>\357\263", 10) = 10
> read(3, "\22\0\10\0\0\0&~\0\0\0\0\30\0\10\0\0\0\2\0\0\0\0\0\17\0\24\0DB2/"..., 113) = 113
> open("/media/snaps/yerf-2013-05-02-03:15:01/DB2/DB2-flat.vmdk", O_RDONLY|O_NOATIME) = 6
> ioctl(5, 0x4020940d, 0x7fffc6d41c60)    = 0
> close(6)                                = 0
> --
> 

Is this the receive side?
Where does the data come from, a local file or via network?

-Arne

> it pauses for a second after "ioctl(5, 0x4020940d"
> it has been running like that for 3 hours now.
> the file its working is large (80gig) and filefrag reports 648862 extends.
> filesystem is mounted with rw,relatime,compress-force=lzo,space_cache
> 
> anything i can do to see what the problem is?
> 
> Remco--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

