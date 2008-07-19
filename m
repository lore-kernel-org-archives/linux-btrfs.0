From: Balaji Rao <balajirrao@gmail.com>
Subject: Re: [RFC][PATCH] introduce a btrfs_iget helper
Date: Sat, 19 Jul 2008 13:55:21 +0530
Message-ID: <200807191355.22058.balajirrao@gmail.com>
References: <200807141152.16772.balajirrao@gmail.com> <1216406826.6932.65.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216406826.6932.65.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 19 July 2008 12:17:06 am Chris Mason wrote:
> On Mon, 2008-07-14 at 11:52 +0530, Balaji Rao wrote:
> > Hello,
> >
> > As suggest by Cristoph, this patch factors out a btrfs_iget helper from
> > btrfs_lookup. This is useful in situations such as in NFS export ops.
> >
> > Comments ?
>
> No objections, but I'll wait for the full NFS patch before pulling this
> one in
Cool. Its almost done. I'll send it once I hunt down a bug I'm chasing now.

-- 
Warm Regards,
Balaji Rao
