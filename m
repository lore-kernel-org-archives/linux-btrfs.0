Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45203 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934130AbcIEQte (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Sep 2016 12:49:34 -0400
Date: Mon, 5 Sep 2016 18:48:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Warn user for minimal RAID5/6
 devices setup
Message-ID: <20160905164802.GZ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>
 <8dc214ad-1ebf-c380-95b7-bdc36bcc9c31@crc.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8dc214ad-1ebf-c380-95b7-bdc36bcc9c31@crc.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2016 at 11:59:07AM +1000, Steven Haigh wrote:
> Is it worthwhile adding a note that RAID5 / RAID6 may very well eat your
> data at this stage?

This depends on the kernel implementation, so it needs to take that into
account. There's a patchset in the works to automatically select mkfs
features based on kernel so a warning for features like raid56 will be
built on top of that.
