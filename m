Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaIYPI6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 11:08:58 -0400
Date: Thu, 25 Sep 2014 17:08:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Add human readable incompat flags output
 for btrfs-show-super
Message-ID: <20140925150856.GC9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411536699-32520-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411536699-32520-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 24, 2014 at 01:31:39PM +0800, Qu Wenruo wrote:
> Add human readable incompat flags output for btrfs-show-super,
> now no longer needs to calculate the hex flags by hand.

Nice. Sample output:

incompat_flags          0x69
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF )

Looks readable and unknown flags are handled as well.
