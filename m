Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751105AbdJNRoe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Oct 2017 13:44:34 -0400
Date: Fri, 13 Oct 2017 20:13:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvol list: don't print deleted subvol as
 TOPLEVEL
Message-ID: <20171013181358.GG3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171013091722.2988-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171013091722.2988-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 05:17:22PM +0800, Lu Fengqi wrote:
> We should use entry->root_id instead of top_id to determine whether it is
> the toplevel subvolume.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Applied, thanks.
