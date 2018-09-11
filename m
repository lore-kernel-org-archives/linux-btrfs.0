Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbeIKTk7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 15:40:59 -0400
Date: Tue, 11 Sep 2018 16:41:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: calibrate extent_end when found a gap
Message-ID: <20180911144120.GA2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180904124201.3287-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180904124201.3287-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2018 at 08:42:01PM +0800, Lu Fengqi wrote:
> The extent_end will be used to check whether there is gap between this
> extent and next extent. If it is not calibrated, check_file_extent will

Do you mean 'synchronized' or 'matching'.

> mistake that there are gaps between the remaining extents.

If this is a bugfix, do you have a testcase? Thanks.
