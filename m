Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50356 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752381AbeGDPpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 11:45:22 -0400
Date: Wed, 4 Jul 2018 17:45:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: Check each block group has corresponding
 chunk at mount time
Message-ID: <20180704154520.GY3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703080830.8300-1-wqu@suse.com>
 <034ca6af-0f07-f9b8-86c0-463333bb41f5@suse.com>
 <e606ab9c-f855-b237-2426-56f3f100bae9@gmx.com>
 <b30b48c9-7e31-bde0-ea9d-10545a4ba613@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b30b48c9-7e31-bde0-ea9d-10545a4ba613@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 12:08:02PM +0300, Nikolay Borisov wrote:
> >> Also for evry patch which fixes a specific issue from one of the
> >> reported on bugzilla.kernel.org just use the Link: tag to point to the
> >> original report on bugzilla that will make it easier to relate the
> >> fixes to the original report.
> > 
> > Never heard of "Link:" tag.
> > Maybe it's a good idea to added it to "submitting-patches.rst"?
> 
> I guess it's not officially documented but if you do git log --grep
> "Link:" you'd see quite a lot of patches actually have a Link pointing
> to the original thread if it has sparked some pertinent discussion. In
> this case those patches are a direct result of a bugzilla bugreport so
> having a Link: tag makes sense.

The tag section of the commit has some predefined tags that could be
somehow "legally binding" like the Signed-off, other can help to gather
statistics about the devlopment process (reviewed, reported, tested) and
the rest is basically free-form that should make sense to a human
reader. So Link: or Bugzilla: would work. There were suggestions to
formalize the links to email discussions but there was also opposition
to formalize too much. Also, the important bits should be in the
changelog as the mail archives are volatile as we've seen already.
