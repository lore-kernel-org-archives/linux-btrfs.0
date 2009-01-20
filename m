From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and swap files on SSD's ?
Date: Tue, 20 Jan 2009 09:31:42 -0500
Message-ID: <1232461902.15042.19.camel@think.oraclecorp.com>
References: <200901171110.22803.chris@csamuel.org>
	 <1232382162.6521.108.camel@think.oraclecorp.com> <4975AA6C.8@schleiser.de>
	 <1232456536.15042.0.camel@think.oraclecorp.com>
	 <3a7f57190901200551s7e9ee262mc3720b5b1452b8dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190901200551s7e9ee262mc3720b5b1452b8dc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-21 at 00:51 +1100, Dmitri Nikulin wrote:
> On Wed, Jan 21, 2009 at 12:02 AM, Chris Mason <chris.mason@oracle.com> wrote:
> > There are patches to support swap over NFS that might make it safe to
> > use on btrfs. At any rate, it is a fixable problem.
> 
> FreeBSD has been able to run swap over NFS for as long as I can
> remember, what is different in Linux that makes it especially
> difficult?

There are two sides to this.  First is the part where writing to NFS can
cause memory allocations which can cause problems when you're trying to
swap so you can do memory allocations.  The swap over NFS patches add
code to deal with that.

The second is an implementation detail of the linux swap file code.  It
expects filesystems don't move blocks around, and takes a mapping of the
blocks in the FS once.

This doesn't work with btrfs because we do move blocks around all the
time.

-chris


