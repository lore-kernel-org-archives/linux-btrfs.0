From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] Btrfs: avoid stack bloat in btrfs_ioctl_fs_info()
Date: Wed, 08 Jun 2011 09:50:37 -0400
Message-ID: <4DEF7E2D.2010603@redhat.com>
References: <4DEF328C.4040801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Arne Jansen <sensille@gmx.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DEF328C.4040801@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/08/2011 04:27 AM, Li Zefan wrote:
> The size of struct btrfs_ioctl_fs_info_args is as big as 1KB, so
> don't declare the variable on stack.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
