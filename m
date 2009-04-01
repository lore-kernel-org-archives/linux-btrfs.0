From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Crash in 2.6.29-rc8
Date: Wed, 01 Apr 2009 13:58:31 -0400
Message-ID: <1238608711.18549.58.camel@think.oraclecorp.com>
References: <49C8F103.1090407@isp-services.nl>
	 <1237916586.5633.14.camel@think.oraclecorp.com>
	 <49D1FDFC.3090904@isp-services.nl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Tom van Klinken / ISP Services BV <tom@isp-services.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49D1FDFC.3090904@isp-services.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-03-31 at 13:26 +0200, Tom van Klinken / ISP Services BV
wrote:
> Hi Chris,
> 
> Chris Mason wrote:
> > On Tue, 2009-03-24 at 15:41 +0100, Tom van Klinken / ISP Services BV
> > wrote:
> >> <CUT>
> > 
> > This is a metadata enospc oops.  You actually had about 400MB free but
> > it was pinned down and waiting for a commit to free it all.
> >
> Today I had a similar issue. See attached kernel trace.
> 
> I'm quite sure the filesystem is not full (I have around 15GB of free 
> space).
> 
> Is their anything I can test/do?
> 
> plain text document attachment (btrfc-trace2.txt)
> Mar 31 00:20:07 db03b btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
> Mar 31 00:20:07 db03b btrfs allocation failed flags 36, wanted 4096
> Mar 31 00:20:07 db03b space_info has 204537856 free, is full

Well, the problem is that you've filled up the metadata areas of your
FS.  So, even though the FS reads 15GB free, the space available for
metadata is full.

I'm working on some patches to help.

-chris


