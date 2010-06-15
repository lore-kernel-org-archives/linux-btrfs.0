From: Nikanth Karthikesan <knikanth@novell.com>
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
Date: Tue, 15 Jun 2010 16:11:35 +0530
Message-ID: <201006151611.36443.knikanth@novell.com>
References: <201006092035.46481.knikanth@novell.com> <87aaqzp39a.fsf@devron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87aaqzp39a.fsf@devron.myhome.or.jp>
List-ID: <linux-btrfs.vger.kernel.org>

Hi OGAWA Hirofumi

Thanks a lot for looking at this and reply.

On Sunday 13 June 2010 17:12:57 OGAWA Hirofumi wrote:
> Nikanth Karthikesan <knikanth@novell.com> writes:
> > I had a need to split a file into smaller files on a thumb drive with no
> > free space on it or anywhere else in the system. When the filesystem
> > supports sparse files(truncate_range), I could create files, while
> > punching holes in the original file. But when the underlying fs is FAT,
> > I couldn't. Also why should we do needless I/O, when all I want is to
> > split/join files. i.e., all the data are already on the disk, under the
> > same filesystem. I just want to do some metadata changes.
> >
> > So, I added two inode operations, namely split and join, that lets me
> > tell the OS, that all I want is meta-data changes. And the file-system
> > can avoid doing lots of I/O, when only metadata changes are needed.
> >
> > sys_split(fd1, n, fd2)
> > 1. Attach the data of file after n bytes in fd1 to fd2.
> > 2. Truncate fd1 to n bytes.
> >
> > Roughly can be thought of as equivalent of following commands:
> > 1. dd if=file1 of=file2 skip=n
> > 2. truncate -c -s n file1
> >
> > sys_join(fd1, fd2)
> > 1. Extend fd1 with data of fd2
> > 2. Truncate fd2 to 0.
> >
> > Roughly can be thought of as equivalent of following commands:
> > 1. dd if=file2 of=file1 seek=`filesize file1`
> > 2. truncate -c -s 0 file2
> >
> > Attached is the patch that adds these new syscalls and support for them
> > to the FAT filesystem.
> >
> > I guess, this approach can be extended to splice() kind of call, between
> > files, instead of pipes. On a COW fs, splice could simply setup blocks
> > as shared between files, instead of doing I/O. It would be a kind of
> > explicit online data-deduplication. Later when a file modifies any of
> > those blocks, we copy blocks. i.e., COW.
> 
> [I'll just ignore implementation for now.., because the patch is totally
> ignoring cache management.]
> 

Ok.

> I have no objections to such those operations (likewise make hole,
> truncate any range, etc. etc.).

As far as FAT is concerned, Sparse files would break the on-disk format?

> However, only if someone have enough
> motivation to implement/maintain those operations, AND there are real
> users (i.e. real sane usecase).

I had a one-off use-case, where I had no free-space, which made me think along 
this line.

1. We have the GNU split tool for example, which I guess, many of us use to 
split larger files to be transfered via smaller thumb drives, for example. We 
do cat many files into one, afterwards. [For this usecase, one can simply dd 
with seek and skip and avoid split/cat completely, but we dont.]

2. It could be useful for multimedia editing softwares, that converts frames 
into video/animation and vice versa.

3. It could be useful for archiving solutions.

4. It would make it easier to implement simple databases. Even help avoid 
needing databases at times. For example, to delete a row, split before & after 
that row, and join leaving it.

So I thought this could be useful generally.

I was also thinking of facilities to add/remove bytes from/at any position in 
the file. As you said truncate any range, but one which can also increase the 
filesize, adding blocks even in between.

IMO It is kind of Chicken-and-egg problem, where applications will start using 
these, only, if it would be available.

> 
> Otherwise, IMO it would be bad than nothing. Because, of course, if
> there are such codes, we can't ignore those anymore until remove
> codes completely for e.g. security reasons. And IMHO, those cache
> managements to such operations are not so easy.
> 

Agreed.

Again, thanks for the comments.

Thanks
Nikanth
