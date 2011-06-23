From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: defrag makes fragmentation worse
Date: Thu, 23 Jun 2011 02:12:38 +0200
Message-ID: <201106230212.39142.johannes.hirte@fem.tu-ilmenau.de>
References: <201106100048.36499.johannes.hirte@fem.tu-ilmenau.de> <20110609235341.GO12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110609235341.GO12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 10 June 2011 01:53:41 David Sterba wrote:
> On Fri, Jun 10, 2011 at 12:48:36AM +0200, Johannes Hirte wrote:
> > I've observed several times that after a btrfs filesystem defrag a file
> > was way more fragmented than before. For example, a file that was
> > recently written, had 10 extents (output from filefrag). After a defrag
> > filefrag showed more than 1900 extents.
> > For curiosity, a simple copy of this "defragmented" file reduced the
> > number of fragments to 1. With a different file I got 63 extents before
> > and over 3000 extents after defrag.
> 
> Do you have compression enabled? Or autodefrag mount option?

No compression, only autodefrag was enabled this time. The last time before I 
saw this, autodefrag didn't exist. 

> 'filefrag -v' will tell you size of the extents, would be interesting
> to see.

Needed some tries but now I have one. Before defrag the file consisted of 174 
extents. Now after defrag there are 786 extents. filefrag -v shows:

Filesystem type is: 9123683e
File size of test1 is 106857600 (26089 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  7037185             299 
   1     299  7989102  7037483     64 
   2     363  7037548  7989165      1 
   3     364  7989538  7037548     64 
   4     428  7037613  7989601      1 
   5     429  7990288  7037613     64 
   6     493  7037678  7990351      1 
   7     494  7992819  7037678     64 
   8     558  7037743  7992882      1 
   9     559  7993037  7037743     64 
  10     623  7037809  7993100      1 
  11     624  7993171  7037809     64 
  12     688  9547471  7993234      1 
  13     689  9547947  9547471     64 
  14     753  9547536  9548010      1 
...
   89   16159  9696920  9696590     64 
 490   16223  9696655  9696983      1 
 491   16224  9700654  9696655     64 
 492   16288  9697127  9700717    276 
 493   16564  9700718  9697402     64 
 494   16628  9697467  9700781      1 
...
 781   25924 12575962 12535459     64 
 782   25988 12535524 12576025      1 
 783   25989 12576026 12535524     64 
 784   26053 12531601 12576089      1 
 785   26054 12541596 12531601     35 eof
test1: 786 extents found

> > It's no problem if defrag can't reduce the fragmentation. But in this
> > case it shouldn't be done at all.
> 
> AFAIK defragmentation just reads the file, marks all pages dirty and
> lets it be written  back. If the free space is fragmented, so will be
> the newly written copy. I do not know if there is some logic comparing
> old and new extent layout (or if it's even possible).

If there is some comparison between old and new, it seems to be broken (or the 
fiemap from btrfs).

regards,
  Johannes
