From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 00/10] Btrfs: backref walking rewrite
Date: Thu, 05 Jan 2012 13:38:28 +0800
Message-ID: <4F053754.2000805@cn.fujitsu.com>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt wrote:
> This patch series is a major rewrite of the backref walking code. The patch
> series Arne sent some weeks ago for quota groups had a very interesting
> function, find_all_roots. I took this from him together with the bits needed
> for find_all_roots to work and replaced a major part of the code in backref.c
> with it.
> 
> It can be pulled from
> 	git://git.jan-o-sch.net/btrfs-unstable for-chris
> There's also a gitweb for that repo on
> 	http://git.jan-o-sch.net/?p=btrfs-unstable
> 

Thanks for the work!

I got a compile warning:

  CC [M]  fs/btrfs/backref.o
fs/btrfs/backref.c: In function 'inode_to_path':
fs/btrfs/backref.c:1312:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'int
