Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43373 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751778AbdK1QNj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:13:39 -0500
Date: Tue, 28 Nov 2017 17:11:41 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: fix verbose value
Message-ID: <20171128161141.GX3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <668fba55-de0e-33d4-647d-44d6bec27aed@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <668fba55-de0e-33d4-647d-44d6bec27aed@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 24, 2017 at 02:24:17PM +0900, Misono, Tomohiro wrote:
> The value of 'verbose' is either 1 (default) or 0 (-q)
> and "verbose >= 2" will not be true.
> 
> After fix this, we get something like:
>  adding device /dev/sde id 2
>  adding device /dev/sdf id 3
> during mkfs time when multiple devices are used.

I think the original idea was to allow different levels of verbosity,
and the "adding device" messages do not bring much value to be printed
by default.

The verbose/quiet options will be handled globally so this code will get
cleaned at that time.
