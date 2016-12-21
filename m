Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753185AbcLUOgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 09:36:14 -0500
Date: Wed, 21 Dec 2016 15:35:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Convert rollback rework for v4.9
Message-ID: <20161221143558.GE12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 02:56:36PM +0800, Qu Wenruo wrote:
> Can be fetched from github:
> https://github.com/adam900710/btrfs-progs.git convert_rework_for_4.9
> 
> This is mainly to fix problems exposed by Chandan's fix for 64K nodesize.

Thanks for the fix. That's a lot of new code that I don't feel
comfortable to put to the upcomming release, so I'll merge 1 and 6 now
and queue the rest for 4.9.1.
