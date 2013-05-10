Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57265 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3EJHeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 03:34:23 -0400
Received: by mail-we0-f174.google.com with SMTP id x53so3644250wes.5
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 00:34:22 -0700 (PDT)
Received: from ?IPv6:2001:980:5211:1:7548:6a6f:bd2d:6d54? ([2001:980:5211:1:7548:6a6f:bd2d:6d54])
        by mx.google.com with ESMTPSA id h8sm1782530wiz.9.2013.05.10.00.34.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 10 May 2013 00:34:21 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: `btrfs receive` almost coming to a halt
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
In-Reply-To: <518CA154.20603@gmx.net>
Date: Fri, 10 May 2013 09:34:20 +0200
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <490AED9A-DB19-421F-A495-773C954B5E35@yerf-it.nl>
References: <01E9FDE0-15C1-429C-AE54-B3A6CAFD7C3B@yerf-it.nl> <518CA154.20603@gmx.net>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 10, 2013, at 9:27 AM, Arne Jansen <sensille@gmx.net> wrote:

> On 09.05.2013 17:14, Remco Hosman - Yerf IT wrote:
>> kernel: 3.9.0
>> btrfs-progs: pulled from git this morning
>> 
>> Trying to receive a 5gig send file. the first bit is fast, doing 10 - 50MB/sec.
>> then it slows down. cpu usage is 50% (dual core machine).
>> when i do a strace, it looks like this, repeating over an over, about 1 piece each second:
>> --
>> read(3, "q\0\0\0\20\0008\352\327o", 10) = 10
>> read(3, "\22\0\10\0\0\0$~\0\0\0\0\30\0\10\0\0\0\2\0\0\0\0\0\17\0\24\0DB2/"..., 113) = 113
>> open("/media/snaps/yerf-2013-05-02-03:15:01/DB2/DB2-flat.vmdk", O_RDONLY|O_NOATIME) = 6
>> ioctl(5, 0x4020940d, 0x7fffc6d41c60)    = 0
>> close(6)                                = 0
>> read(3, "q\0\0\0\20\0\242>\357\263", 10) = 10
>> read(3, "\22\0\10\0\0\0&~\0\0\0\0\30\0\10\0\0\0\2\0\0\0\0\0\17\0\24\0DB2/"..., 113) = 113
>> open("/media/snaps/yerf-2013-05-02-03:15:01/DB2/DB2-flat.vmdk", O_RDONLY|O_NOATIME) = 6
>> ioctl(5, 0x4020940d, 0x7fffc6d41c60)    = 0
>> close(6)                                = 0
>> --
>> 
> 
> Is this the receive side?
> Where does the data come from, a local file or via network?
> 

Yes, this is the receiving side. data comes from a local file.

sometimes it does hit a 'good' portion, then i get a strafe like this:
read(3, "(\300\0\0\17\0N0\346\307", 10) = 10
read(3, "\17\0\24\0DB2/DB2-flat.vmdk.ok\22\0\10\0\0@\25\325"..., 49192) = 49192
pwrite(5,"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,49152,3574939648) = 49152


Managed to find what ioctl 0x4020940d is in the meantime: BTRFS_IOC_CLONE_RANGE, with 32 bytes parameters (4x int64). have not managed to get the parameters yet. i have no idea how to work gbd.

but i guess they are coming from the 113 bytes it is reading.

Remco

> -Arne
> 
>> it pauses for a second after "ioctl(5, 0x4020940d"
>> it has been running like that for 3 hours now.
>> the file its working is large (80gig) and filefrag reports 648862 extends.
>> filesystem is mounted with rw,relatime,compress-force=lzo,space_cache
>> 
>> anything i can do to see what the problem is?
>> 
>> Remco--
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

