Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:30117 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2HORTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 13:19:35 -0400
Date: Wed, 15 Aug 2012 19:19:30 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Kyle Gates <kylegates@hotmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: State of nocow file attribute
Message-ID: <20120815171930.GI25996@vicerveza.homeunix.net>
References: <20120815101229.GH25996@vicerveza.homeunix.net>
 <COL113-W11E89280DE29846698B431B0B60@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <COL113-W11E89280DE29846698B431B0B60@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2012 at 08:05:11AM -0500, Kyle Gates wrote:
> > Is there really a fix upstream for that? Do nocow attribute on files work for
> > anyone already?
> 
> IIRC the nocow attribute seems to work if the volume is mounted with "nodatasum"

Shouldn't nocow mean also nodatasum *only for that file*? I find it a bit
useless, to require whole fs nodatasum for per-file nocow to work.

Thank you,
Lluís.
