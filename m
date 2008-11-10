From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix csum error for compressed data
Date: Mon, 10 Nov 2008 07:12:31 -0500
Message-ID: <1226319151.12914.1.camel@think.oraclecorp.com>
References: <4917FFB0.2000100@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4917FFB0.2000100@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-11-10 at 17:32 +0800, Yan Zheng wrote:
> Hello,
> 
> The decompress code doesn't take the logical offset in extent
> pointer into account. If the logical offset isn't zero, data
> will be decompressed into wrong pages. Thank you,
> 

Ah, thanks Yan.


I'll push this out along with a few other fixes from the weekend
shortly.

-chris


