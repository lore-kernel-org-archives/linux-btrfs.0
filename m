From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Btrfs experimental branch rebased
Date: Sat, 21 Feb 2009 15:44:10 -0600
Message-ID: <49A075AA.6080606@austin.ibm.com>
References: <1234969860.23031.18.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234969860.23031.18.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Hello everyone,
>
> My experimental performance fixes would occasionally trigger corruptions
> under load, so I've folded an incremental fix back in and rebased the
> experimental branch.  This was done to prevent git bisects later on from
> landing on the bad commit and corrupting some poor tester's FS.
>
> This only affects the experimental branch of btrfs-unstable, which is
> not what you get when you clone the tree unless you specifically ask for
> it.
>
> It also now includes Josef's ENOSPC work, which is a big improvement in
> enospc handling.  He has one set of fixes pending to avoid early enospc
> on metadata, and I'll push that out once he sends them along.
>
> Steve, most of the performance fixes are aimed at the mail server raid
> workload, and I'd be curious to see how it compares on your hardware.
>   

OK, I've been out of the country without internet access for  the week.  
Will try to get some runs in on Monday when I get back to the office.

> I'm afraid that mount -o noatime is required to get good numbers though,
> the cow  triggered by atime updates is fairly expensive compared with
> ext[34].
>
>   
Ok, I'll give it  a try with and without noatime.

> The experimental branch can be cloned with:
>
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git experimental
>
> It has four main groups of changes:
>
> 1) Create an async queue of extent allocation tree modifications.  This
> allows the mods to be done outside of critical locks and it allows them
> to be ordered for less seeky IO.
>
> 2) Turn btrfs_unlink into a partially async operation.  This allows
> unlinks to complete in the background without the directory mutex held.
>
> 3) Josef's ENOSPC work.  This focuses on better accounting of delayed
> allocations, and covers the majority of the enospc problem.
>
> 4) Stack footprint reduction.  The async extent allocation tree mods and
> Josef's ENOSPC work both significantly reduce the depth of the call
> chains required to do given operations by doing extent allocation tree
> mods at different times.
>
> The experimental tree also has commits that reduce stack foot print on a
> number of functions, and it reorders some extent allocation tree mods
> for better batching at a more stack friendly time.
>
> -chris
>
>   
Steve

