From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix uninitialized return value
Date: Tue, 14 Jun 2011 10:58:07 +0800
Message-ID: <4DF6CE3F.3010302@cn.fujitsu.com>
References: <1307978303-2756-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307978303-2756-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

23:18, David Sterba wrote:
> When allocation fails in btrfs_read_fs_root_no_name, ret is not set
> although it is returned, holding a garbage value.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>

Thanks! My gcc doesn't warn on this..

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

