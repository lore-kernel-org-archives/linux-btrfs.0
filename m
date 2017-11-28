Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751889AbdK1Ogc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 09:36:32 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AF4B6ADF4
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2017 14:36:30 +0000 (UTC)
Date: Tue, 28 Nov 2017 15:34:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 4/4] btrfs-progs: test/mkfs: Test if the minimal
 device size is valid
Message-ID: <20171128143433.GP3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171101013043.19294-1-wqu@suse.com>
 <20171101013043.19294-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171101013043.19294-5-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 09:30:43AM +0800, Qu Wenruo wrote:
> New test case to test if the minimal device size given by "mkfs.btrfs"
> failure case is valid.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
