From: Josef Bacik <josef@redhat.com>
Subject: Re: Wretched Excess - a 62T btrfs filesystem
Date: Thu, 4 Mar 2010 15:37:47 -0500
Message-ID: <20100304203744.GA8678@localhost.localdomain>
References: <4B8E787C.4080001@ctio.noao.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim Hughes <jhughes@ctio.noao.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B8E787C.4080001@ctio.noao.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 03, 2010 at 11:55:56AM -0300, Jim Hughes wrote:
> Folks:
>
> Thought you all might be interested to know we've just built a  
> "Backblaze Pod" (see  
> http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-build-cheap-cloud-storage/) 
> running Fedora 12 and your latest (as of yesterday) GIT kernel snapshot.
>
> We mounted *all 45 disks* into one huge 62Tb btrfs RAID10 filesystem,  
> and so far it works just great!
>
> I'd be interested in your comments as to pitfall, problems you all see  
> in creating such a huge btrfs file system...
>

Well thats cool.  The only thing that may start to cause problems is as you fill
it up, the time it takes to cache block groups is going to take _forever_.
Thankfully we only cache block groups on demand, and we try to do it in a way
that we save the crappiest ones for last, so even that probably won't be
terrible.  As of right now balance's will _suck_, since they try to move all
block groups, but IIRC Yan is working on making balances take less time.  Other
than that everything should work just as well as if it were a 10gb volume.
Thanks,

Josef
