Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44418 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754079AbdBGS1o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 13:27:44 -0500
Date: Tue, 7 Feb 2017 19:27:13 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: better document btrfs receive security
Message-ID: <20170207182713.GD3366@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170203134858.75210-1-ahferroin7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170203134858.75210-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 03, 2017 at 08:48:58AM -0500, Austin S. Hemmelgarn wrote:
> This adds some extra documentation to the btrfs-receive manpage that
> explains some of the security related aspects of btrfs-receive.  The
> first part covers the fact that the subvolume being received is writable
> until the receive finishes, and the second covers the current lack of
> sanity checking of the send stream.
> 
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

Applied, thanks.
