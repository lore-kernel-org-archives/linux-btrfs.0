Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878AbcDYNuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 09:50:24 -0400
Date: Mon, 25 Apr 2016 15:50:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: primary location of btrfs-progs changelog: The wiki?
Message-ID: <20160425135012.GK23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAD=QJKh50oFh+eEDte4BncgwRuiuJmC1wyiPG3HBVqOkLD2Wng@mail.gmail.com>
 <20160425111249.GB23222@twin.jikos.cz>
 <CAD=QJKgRSEQwMyLiBgrWWiD+9oUWSP=r9jEOFXiHhubq=4w6wQ@mail.gmail.com>
 <20160425113638.GD23222@twin.jikos.cz>
 <CAD=QJKhbd2dUmecHKNFrPxS9dH+LMKQFhsznQbucaM=8PC3EeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=QJKhbd2dUmecHKNFrPxS9dH+LMKQFhsznQbucaM=8PC3EeA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2016 at 08:06:47AM -0400, Nicholas D Steeves wrote:
> On 25 April 2016 at 07:36, David Sterba <dsterba@suse.cz> wrote:
> > The conversion looks relatively ok, indentation could be 2 spaces and
> > all bullet lists with '*'. Thanks.
> 
> Done.  I also added one line before each new version.  I've attached
> it, since it's just one file; however, if you prefer I can clone your
> repo on github and submit it that way.

Thanks. I had a look how a changes file is usually formatted and made
further changes: fixed ordering of the minor releases, added exact dates
of release and un-indented in a few more places, plus some minor fixes.
