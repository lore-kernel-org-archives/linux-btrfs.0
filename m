From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Mon, 18 Aug 2008 20:16:19 -0400
Message-ID: <20080819001618.GA16423@infradead.org>
References: <200807210201.56690.balajirrao@gmail.com> <200808171821.43874.balajirrao@gmail.com> <1218977763.3184.288.camel@pmac.infradead.org> <200808171854.14275.balajirrao@gmail.com> <1218980439.3184.304.camel@pmac.infradead.org> <1219087412.14063.22.camel@think.oraclecorp.com> <1219088029.3184.413.camel@pmac.infradead.org> <1219088859.14063.35.camel@think.oraclecorp.com> <1219090839.3184.436.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219090839.3184.436.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 18, 2008 at 09:20:39PM +0100, David Woodhouse wrote:
> On Mon, 2008-08-18 at 15:47 -0400, Chris Mason wrote:
> > Lets pretend I had put in commments something like the code below.
> > The important part is that directories have only one link, so they
> > have only one backref.
> 
> OK. Now can I rip that code out anyway? The VFS will never call
> btrfs_lookup() for ".." -- not since the 2.2 kernel :)

If you get_parent doesn't call into the lowlevel lookup code it doesn't
need to handle "..".  But most filesystems end up reusing the lookup
code for get_parent.
