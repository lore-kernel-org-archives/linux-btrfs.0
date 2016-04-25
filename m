Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbcDYLgu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 07:36:50 -0400
Date: Mon, 25 Apr 2016 13:36:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: primary location of btrfs-progs changelog: The wiki?
Message-ID: <20160425113638.GD23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAD=QJKh50oFh+eEDte4BncgwRuiuJmC1wyiPG3HBVqOkLD2Wng@mail.gmail.com>
 <20160425111249.GB23222@twin.jikos.cz>
 <CAD=QJKgRSEQwMyLiBgrWWiD+9oUWSP=r9jEOFXiHhubq=4w6wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=QJKgRSEQwMyLiBgrWWiD+9oUWSP=r9jEOFXiHhubq=4w6wQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2016 at 07:24:27AM -0400, Nicholas D Steeves wrote:
> On 25 April 2016 at 07:12, David Sterba <dsterba@suse.cz> wrote:
> > On Fri, Apr 22, 2016 at 08:41:36PM -0400, Nicholas D Steeves wrote:
> >> I'm just wondering where the primary location of the btrfs-progs
> >> changelog is located
> >
> > At the moment it's the release announcement in this mailinglist, that
> > gets copied to the wiki with some formatting adjustments. I'm willing to
> > copy the announcement text to a file in git (and will do for the next
> > release). But at the moment I won't add all the past changelogs so if
> > anybody wants to do that I'l appreciate that.
> 
> I'd be happy to.  Are you looking for something like:
> 
> curl https://btrfs.wiki.kernel.org/index.php/Changelog | html2text |
> sed '0,/(announcement)/d;/By version (linux kernel)/Q' | gzip -9 >
> changelog
> 
> With some formatting adjustments?

The conversion looks relatively ok, indentation could be 2 spaces and
all bullet lists with '*'. Thanks.
