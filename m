Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbcDYLNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 07:13:01 -0400
Date: Mon, 25 Apr 2016 13:12:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: primary location of btrfs-progs changelog: The wiki?
Message-ID: <20160425111249.GB23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAD=QJKh50oFh+eEDte4BncgwRuiuJmC1wyiPG3HBVqOkLD2Wng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=QJKh50oFh+eEDte4BncgwRuiuJmC1wyiPG3HBVqOkLD2Wng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2016 at 08:41:36PM -0400, Nicholas D Steeves wrote:
> I'm just wondering where the primary location of the btrfs-progs
> changelog is located, because I'd like to include upstream changes in
> the Debian package.  Is it really the wiki?  If so, it would seem my
> options are copying+pasting with every release, or writing a script to
> download the page, convert it to text, and then do something like cut
> everything before By version (btrfs-progs) and everything after By
> version (linux kernel).

At the moment it's the release announcement in this mailinglist, that
gets copied to the wiki with some formatting adjustments. I'm willing to
copy the announcement text to a file in git (and will do for the next
release). But at the moment I won't add all the past changelogs so if
anybody wants to do that I'l appreciate that.
