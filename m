Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbbKLKhA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 05:37:00 -0500
Date: Thu, 12 Nov 2015 11:35:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Regression in btrfs: properly set the termination value of
 ctx->pos in readdir
Message-ID: <20151112103523.GI6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56432D2A.5040506@profihost.ag>
 <CAHji153qQPDyO+Ajv3O+FE991DjPG3y1t35091s8t9S4+w5k3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAHji153qQPDyO+Ajv3O+FE991DjPG3y1t35091s8t9S4+w5k3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2015 at 01:22:19PM +0100, Holger Hoffstätte wrote:
> > the patch btrfs: properly set the termination value of ctx->pos in
> > readdir introduces a regression to me.
> >
> > A lot of stuff runs in "endless" or long running loops.
> 
> Just tested this and can confirm something is off.
> In a directory with several files, create a new directory and move all
> files into the new subdir.
> 
> An immediately following ls will hang. The problem goes away after a
> manual sync.

I can reproduce the hang, thanks.
