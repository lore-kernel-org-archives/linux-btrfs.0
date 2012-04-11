From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: inc iversion whenever we modify ctime
Date: Wed, 11 Apr 2012 14:20:28 -0400
Message-ID: <20120411182028.GC2506@localhost.localdomain>
References: <1334165137-3016-1-git-send-email-josef@redhat.com>
 <20120411181601.GA23876@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120411181601.GA23876@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 08:16:01PM +0200, David Sterba wrote:
> On Wed, Apr 11, 2012 at 01:25:37PM -0400, Josef Bacik wrote:
> > The cthon tests are failing some because the iversion didn't change whenever
> > we do some operations.  Basically iversion needs to change anytime the ctime
> > would have changed, so go through and make everybody change their iversion
> > if we change their ctime.  Thanks,
> 
> IMHO it makes sense to fold the changes into
> 
>   "Btrfs: use i_version instead of our own sequence"

Yeah I can do that, just did it this way so I wasn't rebasing on Bruce while
he's running his nfs tests.  Thanks,

Jose f
