From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 3/3] Btrfs: add basic DIO read support
Date: Fri, 7 May 2010 09:40:37 -0400
Message-ID: <20100507134035.GA3360@localhost.localdomain>
References: <20100506190101.GD13974@dhcp231-156.rdu.redhat.com> <20100507095537.GD19699@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20100507095537.GD19699@shareable.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 07, 2010 at 10:55:37AM +0100, Jamie Lokier wrote:
> Josef Bacik wrote:
> > 3) Lock the entire range during DIO.  I originally had it so we would lock the
> > extents as get_block was called, and then unlock them as the endio function was
> > called, which worked great, but if we ever had an error in the submit_io hook,
> > we could have locked an extent that would never be submitted for IO, so we
> > wouldn't be able to unlock it, so this solution fixed that problem and made it a
> > bit cleaner.
> 
> Does this prevent concurrent DIOs to overlapping or nearby ranges?
> 

It just prevents them from overlapping areas.  Thanks,

Josef

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
