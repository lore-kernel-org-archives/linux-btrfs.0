Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752828AbeAHRZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 12:25:10 -0500
Date: Mon, 8 Jan 2018 18:23:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans@knorrie.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: Fix progs_extra build failures
Message-ID: <20180108172302.GC13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171223205238.19678-1-hans@knorrie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171223205238.19678-1-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 23, 2017 at 09:52:36PM +0100, Hans van Kranenburg wrote:
> Alternatively, it might be a better idea to just remove the deprecated source
> files, since this is not the first time build failures in them went unnoticed.

btrfs-show-super and btrfs-calc-size have been deprecated since
2016-11-22, maybe it's time to remove them from git. I'll apply the
patches, with Hugo's S-O-B line, thanks.
