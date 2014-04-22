Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:47089 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbaDVPMo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 11:12:44 -0400
Date: Tue, 22 Apr 2014 17:12:34 +0200
From: Xavier Bassery <xavier@bartica.org>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: read global reserve size from space infos
Message-ID: <20140422171234.51a9fffb@renoir.lan>
In-Reply-To: <20140422140900.GA30423@carfax.org.uk>
References: <1398172800-19548-1-git-send-email-dsterba@suse.cz>
	<20140422140900.GA30423@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Apr 2014 15:09:00 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:

> On Tue, Apr 22, 2014 at 03:20:00PM +0200, David Sterba wrote:
> > Kernels 3.15 > export the global block reserve as a space info
> > presented by 'btrfs fi df' but would display 'unknown' instead of
> > some meaningful string.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > ---
> > 
> > Global_rsv or GlobalRsv or Globalrsv or something else?
> 
>    Personally, I'd probably go for the camel case GlobalRsv, or
> possibly GlbReserve. (Assuming that it's going to be only a single
> token without whitespace to make parsing easier).

I second the camel case (if whitespace is to be avoided) and if I may
put my two cents in, what about GlobalReserve?
As pointed by Hugo, this has the same length as Data+Metadata.

Xavier
