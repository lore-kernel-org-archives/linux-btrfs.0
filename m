From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 4/4] xfstests: Add support for btrfs in 079
Date: Fri, 29 Jul 2011 16:30:12 +0200
Message-ID: <4E32C3F4.8040505@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de> <0cbb002def872039fd8c0bb90ceb5f6bf0e15b02.1311776403.git.sbehrens@giantdisaster.de> <20110728085158.GD3407@infradead.org> <4E32A67E.9070306@giantdisaster.de> <20110729123028.GA4764@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110729123028.GA4764@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 7/29/2011 2:30 PM, Christoph Hellwig wrote:
> On Fri, Jul 29, 2011 at 02:24:30PM +0200, Stefan Behrens wrote:

>> The difference between the filesystems is whether the append-only
>> flag from the directory is inherited to the newly create file inside
>> that directory. XFS does not inherit that append-only flag, ext2,
>> ext3, ext4 and btrfs do inherit it.

> Having different behaviour for different filesystems is a bad thing,
> and given that XFS is the lonely one out there I think we should
> remove the inheritance.  I'll preparate a patch for it.

In order to make it consistent, it would be needed to _add_ the
inheritance to XFS, not to remove it from XFS. Or to remove it from
ext2, ext3, ext4 and btrfs.

A different thread is whether it makes sense to inherit this flag
from directories to files. I would prefer to not inherit the
append-only flag from a directory to files created in that
directory, because the use case for setting the append-only flag
on directories is different to the use case for having the flag set
on files. I cannot imagine use cases where the inheritance of this
flag from the directory to the file is useful.
But I cannot find real-world use cases for setting this flag on
directories anyway, to all imaginable needs in this area the
solution is the sticky bit on the directory or ACLs.
