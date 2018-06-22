Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41926 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbeFVLq5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 07:46:57 -0400
Date: Fri, 22 Jun 2018 13:44:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add more details while checking tree block
Message-ID: <20180622114404.GB24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2018 at 09:52:15AM +0800, Su Yue wrote:
> For easier debug, print eb->start if level is invalid.
> Also make print clear if bytenr found is not expected.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
