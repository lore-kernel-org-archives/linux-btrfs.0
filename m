From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal
 fragmentation in Btrfs)
Date: Fri, 18 Jun 2010 11:10:17 -0400
Message-ID: <20100618151017.GN27466@think>
References: <4C07C321.8010000@redhat.com>
 <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
 <4C1B7560.1000806@gmail.com>
 <20100618134755.GG27466@think>
 <4C1B8B4A.9060308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C1B8B4A.9060308@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 18, 2010 at 05:05:46PM +0200, Edward Shishkin wrote:
> Chris Mason wrote:
> >On Fri, Jun 18, 2010 at 03:32:16PM +0200, Edward Shishkin wrote:
> >>Mat wrote:
> >>>On Thu, Jun 3, 2010 at 4:58 PM, Edward Shishkin <edward@redhat.com> wrote:
> >>>>Hello everyone.
> >>>>
> >>>>I was asked to review/evaluate Btrfs for using in enterprise
> >>>>systems and the below are my first impressions (linux-2.6.33).
> >>>>
> >>>>The first test I have made was filling an empty 659M (/dev/sdb2)
> >>>>btrfs partition (mounted to /mnt) with 2K files:
> >>>>
> >>>># for i in $(seq 1000000); \
> >>>>do dd if=/dev/zero of=/mnt/file_$i bs=2048 count=1; done
> >>>>(terminated after getting "No space left on device" reports).
> >>>>
> >>>># ls /mnt | wc -l
> >>>>59480
> >>>>
> >>>>So, I got the "dirty" utilization 59480*2048 / (659*1024*1024) = 0.17,
> >>>>and the first obvious question is "hey, where are other 83% of my
> >>>>disk space???" I looked at the btrfs storage tree (fs_tree) and was
> >>>>shocked with the situation on the leaf level. The Appendix B shows
> >>>>5 adjacent btrfs leafs, which have the same parent.
> >>>>
> >>>>For example, look at the leaf 29425664: "items 1 free space 3892"
> >>>>(of 4096!!). Note, that this "free" space (3892) is _dead_: any
> >>>>attempts to write to the file system will result in "No space left
> >>>>on device".
> >
> >There are two easy ways to fix this problem.  Turn off the inline
> >extents (max_inline=0) or allow splitting of the inline extents.  I
> >didn't put in the splitting simply because the complexity was high while
> >the benefits were low (in comparison with just turning off the inline
> >extents).
> 
> Hello, Chris. Thanks for response!
> I afraid that both ways won't fix the problem. Look at this leaf:
> 
> [...]
> leaf 29425664 items 1 free space 3892 generation 8 owner 5
> fs uuid 50268d9d-2a53-4f4d-b3a3-4fbff74dd956
> chunk uuid 963ba49a-bb2b-48a3-9b35-520d857aade6
>        item 0 key (320 XATTR_ITEM 3817753667) itemoff 3917 itemsize 78
>                location key (0 UNKNOWN 0) type 8
>                namelen 16 datalen 32 name: security.selinux
> [...]
> 
> There is no inline extents, and what are you going to split here?
> All leafs must be at least a half filled, otherwise we loose all
> boundaries, which provides non-zero utilization..

Right, there is no inline extent because we require them to fit entirely
in the leaf.  So we end up with mostly empty leaves because the inline
item is large enough to make it difficult to push around but not large
enough to fill the leaf.

-chris
