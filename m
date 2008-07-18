From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC][PATCH] introduce a btrfs_iget helper
Date: Fri, 18 Jul 2008 14:47:06 -0400
Message-ID: <1216406826.6932.65.camel@think.oraclecorp.com>
References: <200807141152.16772.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Balaji Rao <balajirrao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200807141152.16772.balajirrao@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-14 at 11:52 +0530, Balaji Rao wrote:
> Hello,
> 
> As suggest by Cristoph, this patch factors out a btrfs_iget helper from
> btrfs_lookup. This is useful in situations such as in NFS export ops.
> 
> Comments ?
> 

No objections, but I'll wait for the full NFS patch before pulling this
one in

-chris


