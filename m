From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs scrub: extent_map reference not freed
Date: Fri, 18 Mar 2011 09:41:53 +0800
Message-ID: <4D82B861.6000301@cn.fujitsu.com>
References: <1300388160-10892-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	idryomov@gmail.com
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300388160-10892-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen wrote:
> scrub_chunk failed to free all extent_maps it referenced, leading to a leak
> of these maps on unmount.
> 
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Arne Jansen <sensille@gmx.net>

I think it's better to fold those fix-up patches into your original scrub
patchset.
