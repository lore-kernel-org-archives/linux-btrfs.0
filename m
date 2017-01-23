Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40947 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbdAWRyi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 12:54:38 -0500
Date: Mon, 23 Jan 2017 18:54:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 5/6] btrfs-progs: convert: Switch to new rollback
 function
Message-ID: <20170123175419.GQ11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
 <20161219065642.25078-6-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161219065642.25078-6-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 02:56:41PM +0800, Qu Wenruo wrote:
> Since we have the whole facilities needed to rollback, switch to the new
> rollback.

Sorry, the change from patch 4 to patch 5 seems too big to grasp for me,
reviewing is really hard and I'm not sure I could even do that. My
concern is namely about patch 5/6 that throws out a lot of code that
does not obviously map to the new code.

I can try again to see if there are points where the patch could be
split, but at the moment the patchset is too scary to merge.
