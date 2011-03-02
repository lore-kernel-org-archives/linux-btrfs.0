From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: how to know when all space from a snapshot delete is freed?
Date: Wed, 02 Mar 2011 22:14:49 +0100
Message-ID: <4D6EB349.1050507@libero.it>
References: <iklfnu$efc$1@dough.gmane.org>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, David Nicol <davidnicol@gmail.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <iklfnu$efc$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

David worked for some time to a solution to this kind of problem. But I
don't know if it was merged.

See posts on this ML with subject "PATCH: IOCTL#21 progs"

On 03/02/2011 02:12 PM, Brian J. Murrell wrote:
> For some time after I issue a snapshot delete, the space in the volume
> is freed.  It starts to free quite fast and then the progress slows and
> speeds up again.
> 
> Given that the return from the snapshot delete command is immediate and
> the space is freed asynchronously, how can I determine absolutely that
> the snapshot has been entirely removed and the space freeing operation
> is complete?
> 
> Cheers,
> b.
> 

