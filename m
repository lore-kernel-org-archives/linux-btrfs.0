Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbaDWNah (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 09:30:37 -0400
Date: Wed, 23 Apr 2014 15:30:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Xavier Bassery <xavier@bartica.org>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH] btrfs-progs: read global reserve size from space infos
Message-ID: <20140423133035.GC2027@suse.cz>
Reply-To: dsterba@suse.cz
References: <1398172800-19548-1-git-send-email-dsterba@suse.cz>
 <20140422140900.GA30423@carfax.org.uk>
 <20140422171234.51a9fffb@renoir.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140422171234.51a9fffb@renoir.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 22, 2014 at 05:12:34PM +0200, Xavier Bassery wrote:
> > > Global_rsv or GlobalRsv or Globalrsv or something else?
> > 
> >    Personally, I'd probably go for the camel case GlobalRsv, or
> > possibly GlbReserve. (Assuming that it's going to be only a single
> > token without whitespace to make parsing easier).
> 
> I second the camel case (if whitespace is to be avoided) and if I may
> put my two cents in, what about GlobalReserve?
> As pointed by Hugo, this has the same length as Data+Metadata.

Sounds good, thank you both for input.
