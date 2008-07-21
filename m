From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH 5/5] updated patch for new dir format
Date: Mon, 21 Jul 2008 08:29:54 -0400
Message-ID: <20080721122954.GK15844@unused.rdu.redhat.com>
References: <20080718164350.GI15844@unused.rdu.redhat.com> <1216414634.6932.74.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216414634.6932.74.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 18, 2008 at 04:57:14PM -0400, Chris Mason wrote:
> On Fri, 2008-07-18 at 12:43 -0400, Josef Bacik wrote:
> > Hello,
> > 
> > Last one, applies cleanly.  You'll want to apply these in order otherwise they
> > won't apply properly.  Thanks,
> > 
> 
> I'm getting:
> 
> rm: cannot remove directory `clients/client44': Directory not empty
> 
> On dbench 50 with this one.  Could you please double check that it works
> for you?  Could be that my local merge is hosed.
>

May want to check your local merge, I just ran dbench 50 on my tree and
everything went fine, though I've noticed that my -unstable stuff wasn't quite
up to date, so I've updated my tree and I'm re-running to make sure there aren't
any problems.  Thanks,

Josef 
