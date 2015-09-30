Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbbI3PRy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 11:17:54 -0400
Date: Wed, 30 Sep 2015 17:16:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: =?iso-8859-1?Q?Gabr=EDel_Arth=FAr_P=E9tursson?= <gabriel@system.is>,
        linux-btrfs@vger.kernel.org
Subject: Re: Add stripes filter
Message-ID: <20150930151653.GJ11442@suse.cz>
Reply-To: dsterba@suse.cz
References: <1443463025.16163.6.camel@system.is>
 <20150929120029.GX11442@twin.jikos.cz>
 <560A7FAB.1040607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <560A7FAB.1040607@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 08:10:19AM -0400, Austin S Hemmelgarn wrote:
> On 2015-09-29 08:00, David Sterba wrote:
> > On Mon, Sep 28, 2015 at 05:57:05PM +0000, Gabríel Arthúr Pétursson wrote:
> >> The attached patches to linux and btrfs-progs add support for filtering
> >> based on the number of strips in a block when balancing.
> >
> > What usecase do you want to address? As I understand it, this would help
> > the raid56 rebalancing to process only blockgroups that are not spread
> > accross enough devices.
> This could also be helpful when reshaping a raid10 or raid0 setup.

Right, I forgot to mention it, I should have said "any raid profile that
uses stripes".
