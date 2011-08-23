From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs:make close_ctree() return void
Date: Tue, 23 Aug 2011 09:00:24 +0800
Message-ID: <4E52FBA8.8020508@cn.fujitsu.com>
References: <1314026291-8873-1-git-send-email-wanlong.gao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	chris.mason@oracle.com, Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314026291-8873-1-git-send-email-wanlong.gao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Wanlong Gao wrote:
> From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> 
> Make close_ctree() return void since it always return 0, and fix
> the return value of btrfs_put_super() to consistent with VFS.
> 

I don't quite like this patch. We do have some failure cases in
close_ctree(), but this doesn't fix that while have the FIXME
tag removed.

--
Li Zefan
