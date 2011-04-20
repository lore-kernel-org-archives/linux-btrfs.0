From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: free bitmaps properly when evicting the cache
Date: Wed, 20 Apr 2011 16:42:18 +0800
Message-ID: <4DAE9C6A.30006@cn.fujitsu.com>
References: <1303158320-29058-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303158320-29058-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> If our space cache is wrong, we do the right thing and free up everything that
> we loaded, however we don't reset the total_bitmaps counter or the thresholds or
> anything.  So in btrfs_remove_free_space_cache make sure to call free_bitmap()
> if it's a bitmap, this will keep us from panicing when we check to make sure we
> don't have too many bitmaps.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

