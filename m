From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs-progs: Update man page for mixed data+metadata option.
Date: Fri, 12 Nov 2010 02:41:05 -0500
Message-ID: <20101112074105.GD10179@dhcp231-156.rdu.redhat.com>
References: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org> <20101111021034.GA6911@dhcp231-156.rdu.redhat.com> <AANLkTimmhCYFtq1y3Lda8O7CRTJOF4OLU-jkJ+yF965X@mail.gmail.com> <20101111125229.GA10179@dhcp231-156.rdu.redhat.com> <4CDCE2F2.5020500@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDCE2F2.5020500@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 12, 2010 at 05:47:14PM +1100, Chris Samuel wrote:
> On 11/11/10 23:52, Josef Bacik wrote:
> 
> > This feature incurs a performance penalty in larger filesystems, it is
> > recommended for use with filesystems of 1 GiB or smaller.
> 
> Maybe slightly stronger, for example:
> 
> This feature incurs a performance penalty for larger filesystems and it
> is ONLY recommended for use with filesystems of 1 GiB or smaller.
> 
> Is it worth having a check and a warning printed if a user does
> try and make a filesystem larger than 1GiB with this option ?
> 
> Just in case they don't RTFM...
>

No because depending on your usage it's actually kind of usefull for anything
less than 5 GiB, and you're only looking at about a 5-10% perf degredation when
using it on larger filesystems.  Thanks,

Josef 
