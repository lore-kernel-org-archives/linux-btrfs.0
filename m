From: Chris Ball <cjb@laptop.org>
Subject: Re: can subvolumes be specified as compressed?
Date: Thu, 29 Jul 2010 23:50:58 -0400
Message-ID: <m3k4odr5jx.fsf@pullcord.laptop.org>
References: <AANLkTi=_gp3hbXjqCnpzHJRAkBhRZqVZ1V5jhg1B0RAV@mail.gmail.com>
	<4C5139FB.8070504@cn.fujitsu.com>
	<AANLkTi=HwyeSxwMNXWTCDzpzDMqoza1DcTuEzS6oirXF@mail.gmail.com>
	<AANLkTinOWkZMDGkgEk0yrGBLDKX6a2ocNcq_b-dKVncN@mail.gmail.com>
	<m3pqy5ra9f.fsf@pullcord.laptop.org>
	<AANLkTik-0PdjpjNgufGy6n+DawgAkGhv2uuY4BkVmAEV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
To: Wang Shaoyan <stufever@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik-0PdjpjNgufGy6n+DawgAkGhv2uuY4BkVmAEV@mail.gmail.com>
	(Wang Shaoyan's message of "Fri, 30 Jul 2010 11:21:58 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > I don't know whether this demand, which specified some subvolumes
   > or directories to be compressed, conflict with the design of
   > btrfs's compression feature, may be they want to do this thing
   > well, and everyone will enable the compression feature, rather
   > than throw the decision to user to determine which should
   > compress.

You can't tell whether you can compress data well until you've already
spent CPU compressing it, though.  Right now we have a useful metric
of "if parts of the file fail to compress, bail out on compressing the
rest of the file, both now and in the future"; but it's only a metric.
There are cases this fails on, such as a tar archive that starts out
with JPEGs and continues with large (compressible) text files.

I think the argument that we don't need to offer user control because
we can just do a good job all the time only works if it's actually
true that we can do a good job all the time, and I don't think that's
true here.  So, I still support user control of the per-inode flag.

(I agree about the subvol flags; I think being able to set quotas and
compression per-subvol is on the roadmap and just not done yet.)

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
