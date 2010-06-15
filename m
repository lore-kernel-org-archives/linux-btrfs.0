From: "David Pottage" <david@electric-spoon.com>
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
Date: Tue, 15 Jun 2010 16:16:06 +0100
Message-ID: <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
References: <201006092035.46481.knikanth@novell.com>
    <87aaqzp39a.fsf@devron.myhome.or.jp>
    <201006151611.36443.knikanth@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Christoph Hellwig" <hch@lst.de>,
	"Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: "Nikanth Karthikesan" <knikanth@novell.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006151611.36443.knikanth@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 15/06/10 11:41, Nikanth Karthikesan wrote:

> I had a one-off use-case, where I had no free-space, which made me
> think along this line.
>
> 1. We have the GNU split tool for example, which I guess, many of us
> use to split larger files to be transfered via smaller thumb drives,
> for example. We do cat many files into one, afterwards. [For this
> usecase, one can simply dd with seek and skip and avoid split/cat
> completely, but we dont.]

I am not sure how you gain here as either way you have to do I/O to get
the split files on and off the thumb drive. It might make sense if the
thumb drive is formated with btrfs, and the file needs to be copied to
another filling system that can't handle large files (eg FAT-16), but I
would say that is unlikely.

> 2. It could be useful for multimedia editing softwares, that converts
> frames into video/animation and vice versa.

Agreed, it would be very useful in this case, as it would save a lot of
I/O and time.

Video files are very big, so a simple edit of removing a few minutes
here and there in an hour long HD recoding will involve copying many
gigabytes from one file to another. Imagine the time and disc space
saved, if you could just make a COW copy of your source file(s), and
then cut out the portions you don't want, and join the parts you do
want together.

Your final edited file would take no extra disc space compared with
your source files, and though it would be fragmented, the fragments
would still be large compared with most files so the performance
penalty to read the file sequentially to play it would be small. Once
you decide you are happy with the final cut, you can delete the source
files and let some background defrag demon tidy up the final file.

> 3. It could be useful for archiving solutions.

Agreed.

> 4. It would make it easier to implement simple databases. Even help
> avoid needing databases at times. For example, to delete a row, split
> before &amp; after that row, and join leaving it.

I am not sure it would be usefull in practice, as these days, if you
need a simple DB in a programming project, you just use SQLite. (Which
has an extremely liberal licence), and let it figure out how to store
your data on disc.

On the other hand, perhaps databases such as SQLite or MySQL would
benifit from this feature for improving their backend storage, especaly
if large amounts of BLOB data is inserted or deleted?

> So I thought this could be useful generally.

Agreed. I think this would be very useful.

I have proposed this kind of thing in the past, and been shouted down,
and told that it should be implemented in the userland program, however
I think it is anachronistic that Unix filesystems have supported sparse
files since the dawn of time, originaly to suit a particular way of
storing fixed size records, but do not support growing or truncating
files except at the end.

> I was also thinking of facilities to add/remove bytes from/at any
> position in the file. As you said truncate any range, but one which
> can also increase the filesize, adding blocks even in between.
>
> IMO It is kind of Chicken-and-egg problem, where applications will
> start using these, only, if it would be available.

I agree that it is a Chicken and egg problem, but I think the
advantages for video editing are so large, that the feature could
become a killer-app when it comes to video editing, as it would improve
performance so much.

-- 
David Pottage

Error compiling committee.c To many arguments to function.

