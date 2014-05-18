Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60374 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751654AbaERGuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 02:50:37 -0400
Message-ID: <5378587B.5010205@cn.fujitsu.com>
Date: Sun, 18 May 2014 14:51:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <20140416171219.GC29256@twin.jikos.cz> <20140517174315.GC2537@carfax.org.uk>
In-Reply-To: <20140517174315.GC2537@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and 
man page for each btrfs subcommand.
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
linux-btrfs@vger.kernel.org, clm@fb.com
Date: 2014年05月18日 01:43
> On Wed, Apr 16, 2014 at 07:12:19PM +0200, David Sterba wrote:
>> On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
>>> Convert the old btrfs man pages to new asciidoc and split the huge
>>> btrfs man page into subcommand man page.
>> I'm merging this patchset into the base series of integration because
>> several patches need to update the docs and it's no longer feasible to
>> keep it in a separate branch from the patches.
>     I've just been poking around in the docs for a completely different
> reason, and I think there's a fairly serious problem (well, as serious
> as problems get with documentation).
>
>     Take, for example, the format for btrfs fi resize:
>
> 'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
>
>     Now, this has just thrown away all of the useful markup which
> indicates the semantics of the command. The asciidoc renders all of
> that text literally and unformatted, making alphasymbolic(*) soup of
> the docs. Compare this to the old roff man page:
>
> \fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fP
Yes, When I convert man pages to asciidoc docs, I have already realized 
the problem.
As mentioned in first patch, most things including the Makefile is 
'stolen' from git,
which means I also apply the git way to deal with the all 'useful' 
markups, *just throw them away* .
>
>     This isn't perfect -- we're missing a \fB around the "max" -- but
> it has text in bold(⁑) and italics(⁂) and neither(☃). I've just looked
> at some of the other pages, and they've also got similar typographical
> problems. This is a lot of fiddly tedious work to get it right, and if
> it doesn't get done now in the initial commit, then we're going to end
> up with poor examples copied for every new feature or docs update,
> making the problem worse before anyone does the work to make it
> better.
As I mentions above, it's meant to be like this, without extra markup 
just like git.

I choose asciidoc and the git documentation style for the following purpose:

1) Split up the huge 'btrfs' man page. (Main purpose of the patchset)

The 'btrfs' man page is so huge that the synopsis is serveral pages long,
force developers to edit man page twice(one for synopsis and one for 
command).
This makes editing frustrating and easy to make things inconsistent.
(serveral synopsis and command description are already inconsistent)

2) Make the documenation more general purpose. (Why choose asciidoc)

Not only generating man pages, but also html/pdf, much like git.

3) Make the original txt more human readable (Why choose git style)

I can use the old markup method but after doing that I realize if you 
read a document full of
markups, the markups have alread lost their meaning.

If using too many markup, there will be other problems:
     3.1) making the synopsis in original txt too long

             This will make both developer and reviewer harder to 
edit/review.
             I choose asciidoc to reduce the hard-to-understand groff 
grammar, if these \fX are
             just converted to ' or `, IMO the cost is still not cut.

     3.2) the markup is not so highlighted if every thing is highlighted

             So I choose only to highlight really important things, 
since with all the bold and itatlic
             things full of the page, there is no difference between all 
normal formatted text.

Due to the above 3 reasons, I think throwing all markup in synopsis is a 
better choice.

Thanks,
Qu
>
>     Hugo.
>
> (*) Or possibly alphashambolic. :)
> (⁑) For literal text
> (⁂) For variables that require substitution by the user
> (☃) For structural syntax indicators such as [] for optional parts, |
>      for alternation and ... to indicate optional continuation of a list
>

