Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966379Ab3HHWVh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 18:21:37 -0400
Date: Fri, 9 Aug 2013 00:21:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Eric Sandeen <sandeen@redhat.com>, fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
Message-ID: <20130808222135.GC5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
 <CAL3q7H7e5r8bHrdR=kS2ueu8iM5q5fe6pkwm8W52fY-odMh6bw@mail.gmail.com>
 <5201652E.4000505@redhat.com>
 <2202309.naAAXLWmb9@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2202309.naAAXLWmb9@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 03:46:20PM +0200, Martin Steigerwald wrote:
> > Because really, the motivation sounds like it's primarily for significant
> > on-disk format changes controlled by mount options.  I understand that
> > motivation more than being able to persist something like "noatime."
> 
> For a hotplug-able SSD having noatime stored persistently IMHO makes a lot of 
> sense as well.

I agree, and we can let btrfs understand noatime (or ro) even if they get
processed by vfs layer.
