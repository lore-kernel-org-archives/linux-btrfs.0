Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbaA0RP5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 12:15:57 -0500
Date: Mon, 27 Jan 2014 18:15:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2] new ioctl TREE_SEARCH_V2
Message-ID: <20140127171556.GZ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 02:28:26PM +0100, Gerhard Heift wrote:
> This patch series adds a new ioctl TREE_SEARCH_V2 with which we could store the
> results in a varying buffer. Now even items larger than 3992 bytes or a large
> amount of items can be returned.
> 
> I have a few questions:
>   Which value should I assign to TREE_SEARCH_V2?

As you did it, it's ok.

>   Should we limit the buffer size?

A sane limit would be ok, and as it's not hardcoded to the data
structure, we can change it later if needed. The only requirement I see
now is to fit the maximum node/leaf size, ie at least 64k.

Big buffer allows to pack lots of items and save the overhead of ioctl
call, but if this is an issue, a separate ioctl should be dedicated to
do that.

>   What about documentation?

I think it's good to document the ioctls in ioctl.h itself, (arguments
and examples if it's not obvious) probably will hit the target audience.
