From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: use do_div to avoid compile errors on 32bit box
Date: Fri, 19 Aug 2011 09:22:51 -0400
Message-ID: <20110819132250.GC28234@dhcp231-156.rdu.redhat.com>
References: <1313747324-27477-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com, dave@jikos.cz
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313747324-27477-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2011 at 05:48:44PM +0800, Liu Bo wrote:
> When doing div operation of u64 type, we need to be careful and use do_div
> to avoid compile ERROR on 32bit box:
> 
> "ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Chris just left for vacation, can you send this to Linus/lkml so it gets pulled
in.  Thanks,

Josef
