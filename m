Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933511AbcKNSYM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:24:12 -0500
Date: Mon, 14 Nov 2016 19:24:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: make block group flags in balance printks
 human-readable
Message-ID: <20161114182407.GQ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161114163747.GO12522@twin.jikos.cz>
 <20161114174434.27383-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161114174434.27383-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2016 at 06:44:34PM +0100, Adam Borowski wrote:
> They're not even documented anywhere, letting users with no recourse but
> to RTFS.  It's no big burden to output the bitfield as words.
> 
> Also, display unknown flags as hex.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Added to 4.10 queue, thanks.
