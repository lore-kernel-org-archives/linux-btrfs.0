From: Chris Mason <chris.mason@oracle.com>
Subject: Re: can't read superblock (but could mount)
Date: Tue, 14 Feb 2012 13:41:31 -0500
Message-ID: <20120214184131.GZ1573@shiny>
References: <20120210203051.Horde.q5KnHsL8999PNXBrH5AlxdA@webmail.df.eu>
 <20120210221842.GU8384@shiny>
 <20120210233959.GV8384@shiny>
 <20120211072725.Horde.8iYhMlNNcXdPNgpNS2yG-PA@webmail.df.eu>
 <20120213130943.GA1573@shiny>
 <alpine.LNX.2.00.1202141832420.11051@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Timo Nentwig <btrfs@nentwig.biz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1202141832420.11051@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2012 at 06:37:16PM +0100, Timo Nentwig wrote:
> On Mon, 13 Feb 2012, Chris Mason wrote:
> 
> >btrfs-debug-tree -b 9872289792 /dev/xxx
> 
> # btrfs-debug-tree -b 9872289792 /dev/loop1
> leaf 9872289792 items 51 free space 0 generation 120351 owner 5

Ok, so this block is full of directory items, definitely not crucial to
mounting.

> 
> # btrfsck /dev/loop1
> Extent back ref already exists for 9872289792 parent 0 root 5
> leaf parent key incorrect 9872289792
> bad block 9872289792

The block is also corrupted, as in the keys in the block aren't what we
expect.

> ref mismatch on [9872289792 4096] extent item 1, found 2
> Incorrect global backref count on 9872289792 found 1 wanted 2
> backpointer mismatch on [9872289792 4096]
> owner ref check failed [9872289792 4096]
> ref mismatch on [9889067008 4096] extent item 1, found 0
> Backref 9889067008 root 5 not referenced
> Incorrect global backref count on 9889067008 found 1 wanted 0
> backpointer mismatch on [9889067008 4096]
> owner ref check failed [9889067008 4096]
> ref mismatch on [37163102208 65536] extent item 1, found 0
> Incorrect local backref count on 37163102208 root 5 owner 3360937
> offset 0 found 0 wanted 1
> backpointer mismatch on [37163102208 65536]
> owner ref check failed [37163102208 65536]
> ref mismatch on [37163814912 36864] extent item 0, found 1
> Backref 37163814912 root 5 owner 3360939 offset 0 num_refs 0 not
> found in extent tree
> Incorrect local backref count on 37163814912 root 5 owner 3360939
> offset 0 found 1 wanted 0
> backpointer mismatch on [37163814912 36864]

And then we have a few other blocks with incorrect reference counts.

> found 15491117056 bytes used err is 1
> total csum bytes: 14764500
> total tree bytes: 366956544
> total fs tree bytes: 317714432
> btree space waste bytes: 90628933
> file data blocks allocated: 16182484992
>  referenced 17813028864
> Btrfs Btrfs v0.19
> 
> # mount /dev/loop1 /tmp/b
> mount: block device /dev/loop1 is write-protected, mounting read-only
> 
> # ls /tmp/b
> bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root
> run  sbin srv  sys  tmp  usr  var  vm
> 
> # echo "hooray!"
> 
> Please explain :)

I didn't do it ;)  All the commands I asked you to run were readonly.
The block is still corrupted.  You've switched from /dev/sda to
/dev/loop0, and loop0 is readonly.  So the readonly mount may be
stopping us from going into that bad branch of your tree (orphan cleanup
perhaps).

Regardless, the corrupt block isn't crucial, you should easily be able to
copy things off.

As for how we got here, I think you said you were originally running
something older than 3.2 when these problems started, correct?

-chris

