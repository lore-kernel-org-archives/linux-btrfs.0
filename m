From: David Sterba <dave@jikos.cz>
Subject: Re: defrag makes fragmentation worse
Date: Fri, 10 Jun 2011 01:53:41 +0200
Message-ID: <20110609235341.GO12709@twin.jikos.cz>
References: <201106100048.36499.johannes.hirte@fem.tu-ilmenau.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106100048.36499.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2011 at 12:48:36AM +0200, Johannes Hirte wrote:
> I've observed several times that after a btrfs filesystem defrag a file was way 
> more fragmented than before. For example, a file that was recently written, had 
> 10 extents (output from filefrag). After a defrag filefrag showed more than 1900 
> extents.
> For curiosity, a simple copy of this "defragmented" file reduced the 
> number of fragments to 1. With a different file I got 63 extents before and over 
> 3000 extents after defrag.

Do you have compression enabled? Or autodefrag mount option?

'filefrag -v' will tell you size of the extents, would be interesting
to see.

> It's no problem if defrag can't reduce the fragmentation. But in this case it 
> shouldn't be done at all. 

AFAIK defragmentation just reads the file, marks all pages dirty and
lets it be written  back. If the free space is fragmented, so will be
the newly written copy. I do not know if there is some logic comparing
old and new extent layout (or if it's even possible).


david
