Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40465 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756301AbeAHTG1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 14:06:27 -0500
Date: Mon, 8 Jan 2018 20:04:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs-progs: check: report more specific info
 about invalid location
Message-ID: <20180108190419.GK13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
 <20171122021716.5957-1-suy.fnst@cn.fujitsu.com>
 <2cb57ad1-2af7-5222-9d62-5fb78333ece3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2cb57ad1-2af7-5222-9d62-5fb78333ece3@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 09:06:55AM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.11.2017 04:17, Su Yue wrote:
> > Previously, it was so useless to print message like
> > "invalid location %d".
> > 
> > Let it print objectid and offset of dir_item too.
> > Debug is easier now.
> > 
> > Suggested-by: Nikolay Borisov <nborisov@suse.com>
> > Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
