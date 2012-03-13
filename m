From: Avi Kivity <avi@redhat.com>
Subject: Re: btrfs oops (autodefrag related?)
Date: Tue, 13 Mar 2012 10:57:59 +0200
Message-ID: <4F5F0C17.8030307@redhat.com>
References: <4F5E4F66.2030701@redhat.com> <20120313000435.GH29393@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120313000435.GH29393@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/13/2012 02:04 AM, Chris Mason wrote:
> On Mon, Mar 12, 2012 at 09:32:54PM +0200, Avi Kivity wrote:
> > Because I'm such a btrfs fanboi I'm running btrfs on my /, all past
> > experience notwithstanding.  In an attempt to recover some performance,
> > I enabled autodefrag, and got this in return:
>
> Hi Avi,
>
> This one was fixed in the 3.3 series.  You can pull from my for-linus
> repo for a commit against 3.2.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>
> The individual fix is here:
>
> http://git.kernel.org/?p=linux/kernel/git/mason/linux-btrfs.git;a=commit;h=87826df0ec36fc28884b4ddbb3f3af41c4c2008f
>
>

Thanks.  Suggest queueing it for -stable.

-- 
error compiling committee.c: too many arguments to function

