From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 4/4] xfstests: Add support for btrfs in 079
Date: Fri, 29 Jul 2011 14:24:30 +0200
Message-ID: <4E32A67E.9070306@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de> <0cbb002def872039fd8c0bb90ceb5f6bf0e15b02.1311776403.git.sbehrens@giantdisaster.de> <20110728085158.GD3407@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110728085158.GD3407@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 7/28/2011 10:51 AM, Christoph Hellwig wrote:
[...]
> I'd suggest to completely drop the stat check, and use the ext2 branch
> unconditionally.  The ioctl is suppored by all major filesystems.
> 
> This also means we can make the test generic, maybe with a _notrun
> instead of an error if FS_IOC_GETFLAGS/FS_IOC_SETFLAGS isn't supported.

I changed it according to your suggestion:
- Get rid of the check for the specific filesystem type.
- Always use FS_IOC_GETFLAGS/FS_IOC_SETFLAGS. This code is inside an
  '#ifdef FS_IOC_SETFLAGS" block in order to never fail compilation.
- Without support for FS_IOC_SETFLAGS, the test completes with _notrun.


What is your opinion about the issue that the test 079 fails on
ext2, ext3, ext4 and btrfs filesystems. Only XFS filesystems succeed
test 079.

mkdir("/mnt3/foo/append-only.d", 0777)  = 0
open("/mnt3/foo/append-only.d", O_RDONLY) = 3
ioctl(3, FS_IOC32_SETFLAGS or FS_IOC_SETFLAGS, 0x7fffaf60b07c) = 0
(this ioctl enables FS_APPEND_FL for the directory)
close(3)
open("/mnt3/foo/append-only.d/newfile-0", O_RDWR|O_CREAT, 0666) = -1
EPERM (Operation not permitted)

One issue is that the file is there (the creation did succeed but
the open for writing did not) what IEEE 1003.1-2004 prohibits
(open() must not create or modify any files if -1 is returned).

The difference between the filesystems is whether the append-only
flag from the directory is inherited to the newly create file inside
that directory. XFS does not inherit that append-only flag, ext2,
ext3, ext4 and btrfs do inherit it.
Test 079 fails when the open("/mnt3/foo/append-only.d/newfile-0",
O_RDWR|O_CREAT, 0666) fails due to the O_RDWR flag. The O_RDWR
flag lets the open() fail when the file has the append-only flag
set. On one type of filesystem the flag is inherited from the
directory, on the other type it is not. Test 079 expects that flag
to not be inherited.

What is your opinion? I would prefer to either change the test to
detect whether the append-only flag is inherited and then interpret
the following system call result depending on the state of the flag,
or to force the flag to a defined state to be independent of the
inheritance behaviour.
