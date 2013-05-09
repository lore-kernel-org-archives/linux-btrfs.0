Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:52743 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3EIPO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 11:14:59 -0400
Received: by mail-we0-f170.google.com with SMTP id u54so3220162wes.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 08:14:58 -0700 (PDT)
Received: from ?IPv6:2001:980:5211:1:952b:9c0c:d3d2:8e3? ([2001:980:5211:1:952b:9c0c:d3d2:8e3])
        by mx.google.com with ESMTPSA id er17sm16424563wic.0.2013.05.09.08.14.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 09 May 2013 08:14:57 -0700 (PDT)
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
Content-Type: text/plain; charset=us-ascii
Subject: `btrfs receive` almost coming to a halt
Message-Id: <01E9FDE0-15C1-429C-AE54-B3A6CAFD7C3B@yerf-it.nl>
Date: Thu, 9 May 2013 17:14:53 +0200
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel: 3.9.0
btrfs-progs: pulled from git this morning

Trying to receive a 5gig send file. the first bit is fast, doing 10 - 50MB/sec.
then it slows down. cpu usage is 50% (dual core machine).
when i do a strace, it looks like this, repeating over an over, about 1 piece each second:
--
read(3, "q\0\0\0\20\0008\352\327o", 10) = 10
read(3, "\22\0\10\0\0\0$~\0\0\0\0\30\0\10\0\0\0\2\0\0\0\0\0\17\0\24\0DB2/"..., 113) = 113
open("/media/snaps/yerf-2013-05-02-03:15:01/DB2/DB2-flat.vmdk", O_RDONLY|O_NOATIME) = 6
ioctl(5, 0x4020940d, 0x7fffc6d41c60)    = 0
close(6)                                = 0
read(3, "q\0\0\0\20\0\242>\357\263", 10) = 10
read(3, "\22\0\10\0\0\0&~\0\0\0\0\30\0\10\0\0\0\2\0\0\0\0\0\17\0\24\0DB2/"..., 113) = 113
open("/media/snaps/yerf-2013-05-02-03:15:01/DB2/DB2-flat.vmdk", O_RDONLY|O_NOATIME) = 6
ioctl(5, 0x4020940d, 0x7fffc6d41c60)    = 0
close(6)                                = 0
--

it pauses for a second after "ioctl(5, 0x4020940d"
it has been running like that for 3 hours now.
the file its working is large (80gig) and filefrag reports 648862 extends.
filesystem is mounted with rw,relatime,compress-force=lzo,space_cache

anything i can do to see what the problem is?

Remco