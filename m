Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:37215 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaJRK3V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 06:29:21 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "Michael Johnson - MJ" <mj@revmj.com>
Subject: Re: strange 3.16.3 problem
Date: Sat, 18 Oct 2014 21:29:16 +1100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <201410181454.19375.russell@coker.com.au> <CAHGunUkzXZ-ybUR_y3tHzGwtn_45gq8YQJyEqteBX3zqWzUakA@mail.gmail.com>
In-Reply-To: <CAHGunUkzXZ-ybUR_y3tHzGwtn_45gq8YQJyEqteBX3zqWzUakA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201410182129.16380.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 18 Oct 2014, "Michael Johnson - MJ" <mj@revmj.com> wrote:
> The NFS client is part of the kernel iirc, so it should be 64 bit.  This
> would allow the creation of files larger than 4gb and create possible
> issues with a 32 bit user space utility.

A correctly written 32bit application will handle files >4G in size.

While some applications may have problems, I'm fairly sure that ls will be ok.

# dd if=/dev/zero of=/tmp/test bs=1024k count=1 seek=5000
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.00383089 s, 274 MB/s
# /bin/ls -lh /tmp/test
-rw-r--r--. 1 root root 4.9G Oct 18 20:47 /tmp/test
# file /bin/ls
/bin/ls: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically 
linked (uses shared libs), for GNU/Linux 2.6.26, 
BuildID[sha1]=0xd3280633faaabf56a14a26693d2f810a32222e51, stripped

A quick test shows that a 32bit ls can handle this.

> I would mount from a client with 64 bit user space and see if the problem
> occurs there.  If so, it is probably not a btrfs issue (if I am
> understanding your environment correctly).

I'll try that later.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
