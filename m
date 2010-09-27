From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Date: Mon, 27 Sep 2010 20:55:45 -0300
Message-ID: <4CA12F01.2@cesarb.net>
References: <4C9AA546.6050201@cesarb.net> <20100923123849.8975fe47.akpm@linux-foundation.org> <20100927222548.GG3610@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, stable@kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?B?TWljaGHFgiBQaW90cm93c2tp?= <mkkp4x4@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	kernel@lists.fedoraproject.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100927222548.GG3610@quack.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Em 27-09-2010 19:25, Jan Kara escreveu:
> [Added CCs for similar ecryptfs warning]
> On Thu 23-09-10 12:38:49, Andrew Morton wrote:
>>> [...]
>>> device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342
>>> /dev/mapper/vg_cesarbinspiro-lv_home
>>> SELinux: initialized (dev dm-3, type btrfs), uses xattr
>>> ------------[ cut here ]------------
>>> WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
>>> Hardware name: Inspiron N4010
>>> Dirtiable inode bdi default != sb bdi btrfs
>    That suggests that we should probably handle such cases in a more generic
> way by changing the code in inode_init_always(). The patch below makes at
> least btrfs happy for me... Could you maybe test it? Thanks.

Applied on top of v2.6.36-rc5-151-g32163f4, running it right now. The 
warning messages no longer happen, and everything seems to be working fine.

Tested-by: Cesar Eduardo Barros <cesarb@cesarb.net>

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
