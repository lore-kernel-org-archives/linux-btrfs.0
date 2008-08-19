From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Tue, 19 Aug 2008 01:21:25 +0100
Message-ID: <1219105285.3184.457.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218980439.3184.304.camel@pmac.infradead.org>
	 <1219087412.14063.22.camel@think.oraclecorp.com>
	 <1219088029.3184.413.camel@pmac.infradead.org>
	 <1219088859.14063.35.camel@think.oraclecorp.com>
	 <1219090839.3184.436.camel@pmac.infradead.org>
	 <20080819001618.GA16423@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Mason <chris.mason@oracle.com>,
	Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080819001618.GA16423@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 20:16 -0400, Christoph Hellwig wrote:
> If you get_parent doesn't call into the lowlevel lookup code it doesn't
> need to handle "..".  But most filesystems end up reusing the lookup
> code for get_parent.

We don't do that in btrfs. It doesn't really seem like a useful thing to
do.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



