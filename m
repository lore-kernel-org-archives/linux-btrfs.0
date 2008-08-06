From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Hot topics for the next release
Date: Wed, 06 Aug 2008 11:13:12 -0400
Message-ID: <1218035592.15342.78.camel@think.oraclecorp.com>
References: <1218032511.15342.73.camel@think.oraclecorp.com>
	 <1218034728.5111.77.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218034728.5111.77.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-06 at 15:58 +0100, David Woodhouse wrote:
> On Wed, 2008-08-06 at 10:21 -0400, Chris Mason wrote:
> > NFS Support
> 
> This is basically ready. All you need in btrfs is the two patches from
> Balaji Rao, which I've updated to apply to the 0.16 and put in
> git.infradead.org/users/dwmw2/btrfs-kernel-unstable.git (along with a
> build fix for 2.6.27-rc2, which is also below).
> 
> The rest of it is a generic problem with NFSD, for which the (current)
> fix is at git.infradead.org/users/dwmw2/nfsexport-2.6.git
> 
> You could perhaps copy the readdir hack into btrfs code for use with
> obsolete kernels -- but to be honest I'd be inclined to leave that for
> the masochists^Wenterprise folks.
> 

We do need the readdir hack, being able to test on older kernels (say
2.6.26) is a big part of attracting and keeping btrfs testers.

Thanks for the trylock_page, I'll toss it in.

-chris


