From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH] Btrfs: add ioctl to set compress or cow per file/dir
Date: Thu, 24 Feb 2011 13:39:52 -0500
Message-ID: <1298572774-sup-6568@think>
References: <4D6627A7.7050001@cn.fujitsu.com> <EE604399-9A36-4E16-82F5-659BA93413B5@dilger.ca>
Content-Type: text/plain; charset=UTF-8
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <EE604399-9A36-4E16-82F5-659BA93413B5@dilger.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andreas Dilger's message of 2011-02-24 13:37:52 -0500:
> On 2011-02-24, at 2:40 AM, liubo wrote:
> >  #define FS_DIRECTIO_FL            0x00100000 /* Use direct i/o */
> > +#define FS_NOCOW_FL            0x00200000 /* Do not cow file */
> > +#define FS_COW_FL            0x00100000 /* Cow file */
> >  #define FS_RESERVED_FL            0x80000000 /* reserved for ext2 lib */
> 
> I'm assuming that FS_COW_FL should not be the same as FS_DIRECTIO_FL?

No, we can do DIRECTIO with COW.

-chris
