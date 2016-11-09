Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41887 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753732AbcKIPCw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 10:02:52 -0500
Date: Wed, 9 Nov 2016 16:02:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Mark Fasheh <mark@fasheh.com>, dsterba@suse.cz,
        James Pharaoh <james@wellbehavedsoftware.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161109150245.GA12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161107140200.GM12522@suse.cz>
 <CAGe7X7n=xkveD4TS2cyfXx5-hydOCHTh=tjDK54h8HWpnK5NqQ@mail.gmail.com>
 <20161107205409.GA20325@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161107205409.GA20325@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2016 at 09:54:09PM +0100, Adam Borowski wrote:
> [1]. For some reasons zfs-on-linux guys didn't implement this yet, despite
> it being an obvious thing on ZFS.

In my understanding, the COW mechanics are different, there are no
extent back references, so this would require some design updates. See
issue 405 at ZoL tracker.
