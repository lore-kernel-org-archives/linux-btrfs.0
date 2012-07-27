Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49608 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2G0LIi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jul 2012 07:08:38 -0400
Date: Fri, 27 Jul 2012 07:08:35 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Message-ID: <20120727110835.GA6933@shiny>
References: <20120718220446.GB3888@merlins.org>
 <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120202124241.GW16796@shiny>
 <20120718220446.GB3888@merlins.org>
 <20120722185848.GA10089@merlins.org>
 <201207222135.11159.Martin@lichtvoll.de>
 <20120722204428.GC3925@merlins.org>
 <20120722224145.GC12951@merlins.org>
 <20120723064202.GB6931@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120723064202.GB6931@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 23, 2012 at 12:42:03AM -0600, Marc MERLIN wrote:
> 
> 22 seconds for 15K files on an SSD is super slow and being 5 times
> slower than a spinning disk with the same data.
> What's going on?

Hi Marc,

The easiest way to figure out is with latencytop.  I'd either run the
latencytop gui or use the latencytop -c patch which sends a text dump to
the console.

This is assuming that you're not pegged at 100% CPU...

https://oss.oracle.com/~mason/latencytop.patch

-chris

