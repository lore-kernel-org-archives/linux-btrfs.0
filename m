From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH RESEND] btrfs: Don't return extent in fiemap if we meet
 with a hole.
Date: Mon, 21 Jun 2010 20:57:23 -0400
Message-ID: <20100622005723.GJ23009@think>
References: <1277102222-3310-1-git-send-email-tao.ma@oracle.com>
 <4C1F167D.3040908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tao.ma@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "jeff.liu" <jeff.liu@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C1F167D.3040908@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 21, 2010 at 03:36:29PM +0800, jeff.liu wrote:
> Hi Chris,
> 
> Could you please also consider another tiny patch below combine with Tao's?
> It fix extent flags to FIEMAP_FLAG_UNWRITTEN if it was fallocate(2) and its "em->block_start ==
> EXTENT_MAP_LAST_BYTE".

Thanks, will do.

-chris
