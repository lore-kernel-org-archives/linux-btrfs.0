From: Chris Ball <cjb@laptop.org>
Subject: Re: can subvolumes be specified as compressed?
Date: Thu, 29 Jul 2010 22:09:16 -0400
Message-ID: <m3pqy5ra9f.fsf@pullcord.laptop.org>
References: <AANLkTi=_gp3hbXjqCnpzHJRAkBhRZqVZ1V5jhg1B0RAV@mail.gmail.com>
	<4C5139FB.8070504@cn.fujitsu.com>
	<AANLkTi=HwyeSxwMNXWTCDzpzDMqoza1DcTuEzS6oirXF@mail.gmail.com>
	<AANLkTinOWkZMDGkgEk0yrGBLDKX6a2ocNcq_b-dKVncN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
To: Wang Shaoyan <stufever@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinOWkZMDGkgEk0yrGBLDKX6a2ocNcq_b-dKVncN@mail.gmail.com>
	(Wang Shaoyan's message of "Fri, 30 Jul 2010 09:29:51 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > So, is there such a method: in a specified directory, the
   > compression feature is enabled, and the file in this directory
   > will be compressed automatically, while the others don't enable
   > compression.

I don't think so, but it wouldn't be difficult -- you'd just set a
per-inode flag on whether to compress, and if it's set on a directory
then it's inherited by the files in that directory.

I think the hold up has been that we've waited for a *generic*
cross-filesystem flag to appear, and it hasn't (or it has and I didn't
notice).  Does anyone have suggestions on how to break the deadlock
there?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
