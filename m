From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] rewrite btrfs_readdir()
Date: Mon, 18 Aug 2008 20:32:32 +0100
Message-ID: <1219087952.3184.409.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218979817.3184.296.camel@pmac.infradead.org>
	 <1218982640.3184.307.camel@pmac.infradead.org>
	 <1218989400.3184.315.camel@pmac.infradead.org>
	 <1219085216.14063.9.camel@think.oraclecorp.com>
	 <1219086483.3184.403.camel@pmac.infradead.org>
	 <1219087489.14063.24.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219087489.14063.24.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-08-18 at 15:24 -0400, Chris Mason wrote:
> Ok, just to double check after rereading the thread, are there known
> bugs in this stuff?  They look sane to me.

No, no known bugs.

This is now working nicely for me -- I can export two separate
subvolumes by NFS, change into a deep subdirectory and reboot the
server, and it all works fine again when the server comes back.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



