From: Sander <sander@humilis.net>
Subject: Re: [PATCH] Btrfs: make lzo the default compression scheme
Date: Fri, 27 May 2011 09:32:13 +0200
Message-ID: <20110527073212.GA28453@attic.humilis.net>
References: <4DDDCB57.6090405@cn.fujitsu.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDDCB57.6090405@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan wrote (ao):
> As the lzo compression feature has been established for quite
> a while, we are now ready to replace zlib with lzo as the default
> compression scheme.

Please be aware that grub2 currently can't load files from a btrfs with
lzo compression (on debian sid/experimental at least).

Just found out the hard way after a kernel upgrade on a system with no
separate /boot partition :-)

Found this: https://bugs.archlinux.org/task/23901

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
