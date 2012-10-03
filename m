Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58183 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab2JCLWR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:17 -0400
Date: Wed, 3 Oct 2012 07:22:14 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS] btrfs filesystem disk-usage
Message-ID: <20121003112214.GK3214@shiny>
References: <1349202970-6700-1-git-send-email-kreijack@gmail.com>
 <20121002234637.GF3214@shiny>
 <CAJHuE_BmvmEteSg8YgcHH3cuB27Bi-j-B=yS7Y2NFhb1L5_Aog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJHuE_BmvmEteSg8YgcHH3cuB27Bi-j-B=yS7Y2NFhb1L5_Aog@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 12:22:06AM -0600, Goffredo Baroncelli wrote:
> On Wed, Oct 3, 2012 at 1:46 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> [...]
> > I like it, thanks.  Could you please update btrfs fi df to show this
> > instead of adding a new command though?
> 
> Hi Chris,
> no problem to update the patches, however I have one suggestion:
> - leave "btrfs fi df" as is to no break any script (if any) which
> would uses it. Hide it from the help and deprecating it in the man
> page. This because the output is very different.
> - renaming "btrfs fi disk-usage" in "btrfs fi disk-free", which make sense.
> 
> Let me know which choiche you prefer.

I think it is better to replace btrfs fi df.  There should not be many
scripts relying on it yet.

-chris
