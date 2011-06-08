From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: use join_transaction in btrfs_evict_inode()
Date: Wed, 08 Jun 2011 09:52:55 -0400
Message-ID: <4DEF7EB7.9070505@redhat.com>
References: <4DEEF2FC.9060209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DEEF2FC.9060209@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2011 11:56 PM, Li Zefan wrote:
> The WARN_ON() in start_transaction() was triggered while balancing.
> 
> The cause is btrfs_relocate_chunk() started a transaction and
> then called iput() on the inode that stores free space cache,
> and iput() called btrfs_start_transaction() again.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
