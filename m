From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 5/5] updated patch for new dir format
Date: Fri, 18 Jul 2008 16:57:14 -0400
Message-ID: <1216414634.6932.74.camel@think.oraclecorp.com>
References: <20080718164350.GI15844@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080718164350.GI15844@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-18 at 12:43 -0400, Josef Bacik wrote:
> Hello,
> 
> Last one, applies cleanly.  You'll want to apply these in order otherwise they
> won't apply properly.  Thanks,
> 

I'm getting:

rm: cannot remove directory `clients/client44': Directory not empty

On dbench 50 with this one.  Could you please double check that it works
for you?  Could be that my local merge is hosed.

-chris


