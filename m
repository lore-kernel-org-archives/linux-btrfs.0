Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46533 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752140AbcKBO7K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 10:59:10 -0400
Date: Wed, 2 Nov 2016 15:59:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v3 4/4] btrfs-progs: remove send-test tool
Message-ID: <20161102145907.GG12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-5-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161101080147.13163-5-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 04:01:46PM +0800, Qu Wenruo wrote:
> Since new "receive --dump" has better output and structure, it's time
> to remove old and function-weak send-test tool.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.com>

As this patch is independet, applied now, no need to resend with the
rest.
