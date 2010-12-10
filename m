From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix sync subvol/snapshot creation
Date: Fri, 10 Dec 2010 10:11:25 +0800
Message-ID: <4D018C4D.6060408@cn.fujitsu.com>
References: <1291941388-17050-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291941388-17050-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Sage Weil wrote:
> We were incorrectly taking the async path even for the sync ioctls by
> passing in &transid unconditionally.
> 

Ha, I fixed this accidentally in my patchset. :)

> There's ample room for further cleanup here, but this keeps the fix simple.
> 
> Signed-off-by: Sage Weil <sage@newdream.net>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
