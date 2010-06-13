From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
Date: Sun, 13 Jun 2010 20:42:57 +0900
Message-ID: <87aaqzp39a.fsf@devron.myhome.or.jp>
References: <201006092035.46481.knikanth@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Nikanth Karthikesan <knikanth@novell.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201006092035.46481.knikanth@novell.com> (Nikanth Karthikesan's
	message of "Wed, 9 Jun 2010 20:35:46 +0530")
List-ID: <linux-btrfs.vger.kernel.org>

Nikanth Karthikesan <knikanth@novell.com> writes:

> I had a need to split a file into smaller files on a thumb drive with no
> free space on it or anywhere else in the system. When the filesystem
> supports sparse files(truncate_range), I could create files, while
> punching holes in the original file. But when the underlying fs is FAT,
> I couldn't. Also why should we do needless I/O, when all I want is to
> split/join files. i.e., all the data are already on the disk, under the
> same filesystem. I just want to do some metadata changes.
>
> So, I added two inode operations, namely split and join, that lets me
> tell the OS, that all I want is meta-data changes. And the file-system
> can avoid doing lots of I/O, when only metadata changes are needed.
>
> sys_split(fd1, n, fd2)
> 1. Attach the data of file after n bytes in fd1 to fd2.
> 2. Truncate fd1 to n bytes.
>
> Roughly can be thought of as equivalent of following commands:
> 1. dd if=file1 of=file2 skip=n
> 2. truncate -c -s n file1
>
> sys_join(fd1, fd2)
> 1. Extend fd1 with data of fd2
> 2. Truncate fd2 to 0.
>
> Roughly can be thought of as equivalent of following commands:
> 1. dd if=file2 of=file1 seek=`filesize file1`
> 2. truncate -c -s 0 file2
>
> Attached is the patch that adds these new syscalls and support for them
> to the FAT filesystem.
>
> I guess, this approach can be extended to splice() kind of call, between
> files, instead of pipes. On a COW fs, splice could simply setup blocks
> as shared between files, instead of doing I/O. It would be a kind of
> explicit online data-deduplication. Later when a file modifies any of
> those blocks, we copy blocks. i.e., COW.

[I'll just ignore implementation for now.., because the patch is totally
ignoring cache management.]

I have no objections to such those operations (likewise make hole,
truncate any range, etc. etc.). However, only if someone have enough
motivation to implement/maintain those operations, AND there are real
users (i.e. real sane usecase).

Otherwise, IMO it would be bad than nothing. Because, of course, if
there are such codes, we can't ignore those anymore until remove
codes completely for e.g. security reasons. And IMHO, those cache
managements to such operations are not so easy.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
