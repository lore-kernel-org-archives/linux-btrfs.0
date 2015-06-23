Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbbFWMmW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 08:42:22 -0400
Date: Tue, 23 Jun 2015 14:42:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Christian Robottom Reis <kiko@async.com.br>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: Re: qgroup limit clearing, was Re: Btrfs progs release 4.1
Message-ID: <20150623124219.GC6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150622150023.GX6761@twin.jikos.cz>
 <201506222052.t5MKqWVM024486@anthem.async.com.br>
 <5588A056.2080003@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5588A056.2080003@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 08:55:02AM +0900, Tsutomu Itoh wrote:
> >      qgroupid         rfer         excl     max_rfer     max_excl
> >      --------         ----         ----     --------     --------
> >      0/261         1.42GiB      1.11GiB     16.00EiB     16.00EiB
> >
> > Is that expected?

No, thanks for the report.

> The following fix is necessary for the kernel to display it correctly.
> 
>   [PATCH] btrfs: qgroup: allow user to clear the limitation on qgroup
>   http://marc.info/?l=linux-btrfs&m=143331495409594&w=2

I missed that it depended on a kernel change, so we should fix it in
userspace, but it's merely a cosmetic fix.
