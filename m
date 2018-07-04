Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752260AbeGDPVj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 11:21:39 -0400
Date: Wed, 4 Jul 2018 17:21:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make sure there is always room for generation
 number
Message-ID: <20180704152136.GV3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530576054-12837-1-git-send-email-zzhsuny@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530576054-12837-1-git-send-email-zzhsuny@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 08:00:54PM -0400, Zhihui Zhang wrote:
> io_ctl_set_generation() assumes that the generation number shares
> the same page with inline CRCs. Let's make sure this is always true.
> 
> Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
