From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch 1/2] Btrfs: double unlock bug in error handling
Date: Wed, 18 Apr 2012 15:06:47 +0300
Message-ID: <20120418120647.GA27101@mwanda>
References: <20120418065903.GE12831@elgon.mountain>
 <4F8EA5AA.2080202@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F8EA5AA.2080202@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2012 at 01:29:46PM +0200, Jan Schmidt wrote:
> On 18.04.2012 08:59, Dan Carpenter wrote:
> I think the correct way to fix this is:
> 

Yeah.  I considered both ways, but I chose the one which makes the
tools happy.  Which is the wrong choice, because taking a pointless
lock is wrong even on the slow path and we should improve the tools.

I'll resend.

regards,
dan carpenter

