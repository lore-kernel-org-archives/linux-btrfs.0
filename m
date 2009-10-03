From: Josef Bacik <josef@redhat.com>
Subject: Re: ENOSPC at 94% full -- and causing BUGs elsewhere?
Date: Sat, 3 Oct 2009 17:55:32 -0400
Message-ID: <20091003215531.GG4350@dhcp231-156.rdu.redhat.com>
References: <20091003122109.GB3116@selene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091003122109.GB3116@selene>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 03, 2009 at 01:21:09PM +0100, Hugo Mills wrote:
>    I've just had the following on my home server. I believe that it's
> btrfs that's responsible, as the machine wasn't doing much other than
> reading/writing on a btrfs filesystem. The process that was doing so
> is now stuck in D+ state, and can't be killed. The timing of the oops
> at the end is also suggestive of being involved in the same incident.
> This is the only btrfs filesystem on the machine.
>

Patches have gone to Linus to fix the enospc problems.  You can try running the
enospc branch of Chris's git tree and it should behave better for you.  Thanks,

Josef 
