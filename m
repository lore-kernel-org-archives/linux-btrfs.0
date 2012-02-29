From: Travis Shivers <ttshivers@gmail.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Tue, 28 Feb 2012 21:00:56 -0600
Message-ID: <CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
 <4F4D8259.2090209@oracle.com> <20120229025027.GB15383@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Gurudas Pai <gurudas.pai@oracle.com>,
	Travis Shivers <ttshivers@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120229025027.GB15383@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Where should I grab the source from? The main repo that you have
listed on your main wiki page
(https://btrfs.wiki.kernel.org/articles/b/t/r/Btrfs_source_repositories=
=2Ehtml)
is down: git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-prog=
s-unstable.git

Has this patch been pushed to a repository where I can grab it?

On Tue, Feb 28, 2012 at 8:50 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Tue, Feb 28, 2012 at 05:41:45PM -0800, Gurudas Pai wrote:
>>
>>
>> ># btrfs-debug-tree /dev/sdh
>> couldn't open because of unsupported option features (8).
>> btrfs-debug-tree: disk-io.c:679: open_ctree_fd: Assertion `!(1)' fai=
led
>>
>>
>>
>>
>> See if following patch helps.
>
> This patch may just fix things (if we're really lucky). =A0If not, ye=
s we
> can help figure out where the problem is and get past it.
>
> -chris
>
>>
>> Author: Chris Mason<chris.mason@oracle.com>
>> Date: =A0 Wed Feb 22 12:36:24 2012 -0500
>>
>> =A0 =A0 Btrfs: clear the extent uptodate bits during parent transid =
failures
>>
>> =A0 =A0 If btrfs reads a block and finds a parent transid mismatch, =
it clears
>> =A0 =A0 the uptodate flags on the extent buffer, and the pages insid=
e it. =A0But
>> =A0 =A0 we only clear the uptodate bits in the state tree if the blo=
ck straddles
>> =A0 =A0 more than one page.
>>
>> =A0 =A0 This is from an old optimization from to reduce contention o=
n the extent
>> =A0 =A0 state tree. =A0But it is buggy because the code that retries=
 a read from
>> =A0 =A0 a different copy of the block is going to find the uptodate =
state bits
>> =A0 =A0 set and skip the IO.
>>
>> =A0 =A0 The end result of the bug is that we'll never actually read =
the good
>> =A0 =A0 copy (if there is one).
>>
>> =A0 =A0 The fix here is to always clear the uptodate state bits, whi=
ch is safe
>> =A0 =A0 because this code is only called when the parent transid fai=
ls.
>>
>> =A0 =A0 Signed-off-by: Chris Mason<chris.mason@oracle.com>
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 1e8d5e5..a4dc892 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3852,10 +3852,9 @@ int clear_extent_buffer_uptodate(struct exten=
t_io_tree *tree,
>> =A0 =A0 =A0 num_pages =3D num_extent_pages(eb->start, eb->len);
>> =A0 =A0 =A0 clear_bit(EXTENT_BUFFER_UPTODATE,&eb->bflags);
>>
>> - =A0 =A0 if (eb_straddles_pages(eb)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 clear_extent_uptodate(tree, eb->start, eb-=
>start + eb->len - 1,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 cached_state, GFP_NOFS);
>> - =A0 =A0 }
>> + =A0 =A0 clear_extent_uptodate(tree, eb->start, eb->start + eb->len=
 - 1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cached_state, =
GFP_NOFS);
>> +
>> =A0 =A0 =A0 for (i =3D 0; i< =A0num_pages; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D extent_buffer_page(eb, i);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (page)
>> --
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
