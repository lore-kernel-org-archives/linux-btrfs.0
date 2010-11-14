From: Shane Shrybman <shrybman@teksavvy.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Sun, 14 Nov 2010 14:55:07 -0500
Message-ID: <1289764507.4303.9.camel@mars>
References: <1289236257.3611.3.camel@mars>  <1289310046-sup-839@think>
	 <1289326892.4231.2.camel@mars>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: aarcange@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289326892.4231.2.camel@mars>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-11-09 at 13:21 -0500, Shane Shrybman wrote:
> On Tue, 2010-11-09 at 08:42 -0500, Chris Mason wrote:
> > Excerpts from Shane Shrybman's message of 2010-11-08 12:10:57 -0500:
> > > Hi,
> > > 
> > > Got an oops last week while rebalancing that seems to have left me with
> > > a corrupted btrfs. Kernel was ~2.6.36 + Transparent hugetlb patchset +
> > > small misc. patchs.
> > 
> > We have a confirmed and reproducible case where the transparent
> > hugepages are corrupting btrfs (and only btrfs).  I'll work with Andrea
> > on figuring out the cause.
> > 
> > So, the first step to trying to fix it is to grab the latest btrfsck and
> > see if some old copies of the super are working:
> > 
> > btrfsck -s 1 /dev/xxx
> > btrfsck -s 2 /dev/xxx
> > 
> 
> Yeah, I tried that with the latest btrfsck (last commit was:
> btrfs-debug-tree: add -d option ...)
> 
> # ./btrfsck  -s 1 /dev/sdc1
> using SB copy 1, bytenr 67108864
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> Segmentation fault
> # ./btrfsck  -s 0 /dev/sdc1
> using SB copy 0, bytenr 65536
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> Segmentation fault
> # ./btrfsck  -s 2 /dev/sdc1
> using SB copy 2, bytenr 274877906944
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> checksum verify failed on 625055924224 wanted C3DFFE41 found FFFFFF88
> Segmentation fault
> # ./btrfsck  -s 3 /dev/sdc1
> using SB copy 3, bytenr 1125899906842624
> No valid Btrfs found on /dev/sdc1
> 
> Hmm, odd that btrfsck -s 0 /dev/sdc1 finds a different checksum than
> before.
> 

Hi Andrea!

Long time since our last bug fix :) I still have fond memories of
2.4.23-aa kernels, best of all time!

I couldn't find any other mention of this corruption issue with THP and
btrfs, so I was just checking to see if there has been any progress?

Regards,

Shane


