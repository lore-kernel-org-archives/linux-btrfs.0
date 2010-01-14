From: Paul Komkoff <i@stingr.net>
Subject: Re: btrfs fallocate woes
Date: Thu, 14 Jan 2010 18:25:58 +0000
Message-ID: <715ea5c11001141025l27c20fe2r243c91a98b09689b@mail.gmail.com>
References: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
	 <aday6k0lhpx.fsf@roland-alpha.cisco.com>
	 <715ea5c11001141024n8a6fa6fy95dfea4d991686c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <715ea5c11001141024n8a6fa6fy95dfea4d991686c9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/1/14 i <i@stingr.net>:
> Nowhere there it is said that size is ceil()'d to a blocksize. Moreover, I never saw an app that does fallocate() and then ftruncate() - every single app out there assumes that posix_fallocate (and fallocate, fwiw), while may allocate more space, will set the file size to something different than offset+len.

Err, of course it's to just offset+len. I may need more sleep (this
won't purge away the fallocate problem though).
-- 
This message represents the official view of the voices in my head
