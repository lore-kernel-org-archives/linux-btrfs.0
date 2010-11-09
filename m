From: Shane Shrybman <shrybman@teksavvy.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Tue, 09 Nov 2010 13:21:32 -0500
Message-ID: <1289326892.4231.2.camel@mars>
References: <1289236257.3611.3.camel@mars>  <1289310046-sup-839@think>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289310046-sup-839@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-11-09 at 08:42 -0500, Chris Mason wrote:
> Excerpts from Shane Shrybman's message of 2010-11-08 12:10:57 -0500:
> > Hi,
> > 
> > Got an oops last week while rebalancing that seems to have left me with
> > a corrupted btrfs. Kernel was ~2.6.36 + Transparent hugetlb patchset +
> > small misc. patchs.
> 
> We have a confirmed and reproducible case where the transparent
> hugepages are corrupting btrfs (and only btrfs).  I'll work with Andrea
> on figuring out the cause.
> 
> So, the first step to trying to fix it is to grab the latest btrfsck and
> see if some old copies of the super are working:
> 
> btrfsck -s 1 /dev/xxx
> btrfsck -s 2 /dev/xxx
> 

Yeah, I tried that with the latest btrfsck (last commit was:
btrfs-debug-tree: add -d option ...)

# ./btrfsck  -s 1 /dev/sdc1
using SB copy 1, bytenr 67108864
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
Segmentation fault
# ./btrfsck  -s 0 /dev/sdc1
using SB copy 0, bytenr 65536
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
Segmentation fault
# ./btrfsck  -s 2 /dev/sdc1
using SB copy 2, bytenr 274877906944
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
Segmentation fault
# ./btrfsck  -s 3 /dev/sdc1
using SB copy 3, bytenr 1125899906842624
No valid Btrfs found on /dev/sdc1

Hmm, odd that btrfsck -s 0 /dev/sdc1 finds a different checksum than
before.


