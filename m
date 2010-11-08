From: Shane Shrybman <shrybman@teksavvy.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Mon, 08 Nov 2010 16:25:50 -0500
Message-ID: <1289251550.3611.9.camel@mars>
References: <1289236257.3611.3.camel@mars> <1289238847-sup-3860@think>
	 <1289248765.3611.6.camel@mars>  <1289250095-sup-1814@think>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289250095-sup-1814@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-11-08 at 16:04 -0500, Chris Mason wrote:
> Excerpts from Shane Shrybman's message of 2010-11-08 15:39:25 -0500:
> > On Mon, 2010-11-08 at 12:55 -0500, Chris Mason wrote:
> > > Excerpts from Shane Shrybman's message of 2010-11-08 12:10:57 -0500:
> > > > Hi,
> > > > 
> > > > Got an oops last week while rebalancing that seems to have left me with
> > > > a corrupted btrfs. Kernel was ~2.6.36 + Transparent hugetlb patchset +
> > > > small misc. patchs.
> > > 
> > > Have you tried the 2.6.36 + the btrfs unstable git tree?  It may be able
> > > to help here.
> > 
> > Ok, I have built and booted the 2.6.36 + the btrfs unstable git tree
> > kernel and ran btrfsck with the same results.
> > 
> > # btrfsck /dev/sdc1
> > checksum verify failed on 625055924224 wanted C3DFFE41 found 9F99998
> > checksum verify failed on 625055924224 wanted C3DFFE41 found 9F99998
> > checksum verify failed on 625055924224 wanted C3DFFE41 found 9F99998
> > Segmentation fault
> 
> Ok, if you pull down the latest btrfs-progs from git, you'll find a new
> option to btrfsck, which tries alternate copies of the super block.
> 
> btrfsck -s 1 /dev/sdc1
> btrfsck -s 2 /dev/sdc1
> btrfsck -s 3 /dev/sdc1
> 
> If we're really lucky, one of these will work.

No luck yet :)

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





