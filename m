From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: btrfs and swap files on SSD's ?
Date: Wed, 21 Jan 2009 00:51:22 +1100
Message-ID: <3a7f57190901200551s7e9ee262mc3720b5b1452b8dc@mail.gmail.com>
References: <200901171110.22803.chris@csamuel.org>
	 <1232382162.6521.108.camel@think.oraclecorp.com>
	 <4975AA6C.8@schleiser.de>
	 <1232456536.15042.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232456536.15042.0.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2009 at 12:02 AM, Chris Mason <chris.mason@oracle.com> wrote:
> There are patches to support swap over NFS that might make it safe to
> use on btrfs. At any rate, it is a fixable problem.

FreeBSD has been able to run swap over NFS for as long as I can
remember, what is different in Linux that makes it especially
difficult?

I've read that swap over non-trivial filesystems is hazardous as it
may lead to a situation in which memory allocation can fail in the
swap/FS code that was meant to make allocation possible again.

If btrfs is to take the role of a RAID and volume manager, it would
certainly be very useful to be able to run swap on it, since that
frees up other volumes from an administrative standpoint.

-- 
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
