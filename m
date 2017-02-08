Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42809 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753833AbdBHNOk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 08:14:40 -0500
Date: Wed, 8 Feb 2017 13:55:53 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: better document btrfs receive security
Message-ID: <20170208125553.GE3366@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170203134858.75210-1-ahferroin7@gmail.com>
 <20170207182713.GD3366@suse.cz>
 <b5e64d04-a992-afcf-55ef-e1ab0a702a71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b5e64d04-a992-afcf-55ef-e1ab0a702a71@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 08, 2017 at 07:29:22AM -0500, Austin S. Hemmelgarn wrote:
> On 2017-02-07 13:27, David Sterba wrote:
> > On Fri, Feb 03, 2017 at 08:48:58AM -0500, Austin S. Hemmelgarn wrote:
> >> This adds some extra documentation to the btrfs-receive manpage that
> >> explains some of the security related aspects of btrfs-receive.  The
> >> first part covers the fact that the subvolume being received is writable
> >> until the receive finishes, and the second covers the current lack of
> >> sanity checking of the send stream.
> >>
> >> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> >
> > Applied, thanks.
> >
> Didn't get a chance to mention this yesterday, but it looks like you 
> hadn't seen the updated version I sent on the third.  Message ID is:
> <20170203193805.96977-1-ahferroin7@gmail.com>

Ah sorry I missed that.

> The only significant difference is that I updated the description for 
> the writablility issue using a much better description from Graham Cobb 
> (with his permission of course).
> 
> If you want, I can send an incremental patch on top of the original to 
> update just that description.

No need to, I'll replace the patch with the latest version. Thanks.
