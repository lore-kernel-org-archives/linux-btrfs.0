Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32035 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbaESNBZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 09:01:25 -0400
Message-ID: <537A00F1.5000207@fb.com>
Date: Mon, 19 May 2014 09:02:41 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, <dsterba@suse.cz>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <20140416171219.GC29256@twin.jikos.cz> <20140517174315.GC2537@carfax.org.uk>
In-Reply-To: <20140517174315.GC2537@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/17/2014 01:43 PM, Hugo Mills wrote:
> On Wed, Apr 16, 2014 at 07:12:19PM +0200, David Sterba wrote:
>> On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
>>> Convert the old btrfs man pages to new asciidoc and split the huge
>>> btrfs man page into subcommand man page.
>>
>> I'm merging this patchset into the base series of integration because
>> several patches need to update the docs and it's no longer feasible to
>> keep it in a separate branch from the patches.
> 
>    I've just been poking around in the docs for a completely different
> reason, and I think there's a fairly serious problem (well, as serious
> as problems get with documentation).
> 
>    Take, for example, the format for btrfs fi resize:
> 
> 'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
> 
>    Now, this has just thrown away all of the useful markup which
> indicates the semantics of the command. The asciidoc renders all of
> that text literally and unformatted, making alphasymbolic(*) soup of
> the docs. Compare this to the old roff man page:
> 
> \fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fP
> 
>    This isn't perfect -- we're missing a \fB around the "max" -- but
> it has text in bold(⁑) and italics(⁂) and neither(☃). I've just looked
> at some of the other pages, and they've also got similar typographical
> problems. This is a lot of fiddly tedious work to get it right, and if
> it doesn't get done now in the initial commit, then we're going to end
> up with poor examples copied for every new feature or docs update,
> making the problem worse before anyone does the work to make it
> better.

Are there issues with the asciidoc form outside of the command summary line?

The reason I ask is that all of these tools have tradeoffs.  If asciidoc
makes our documentation easier to update and easier to keep up to date,
I'm willing to trade that for the perfect summary line.

I think the easiest way to add clarity to the summary (in any markup
language) is by providing examples.  Italics and bolds definitely help,
but examples always win.

-chris

