Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423119AbcFMPPE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jun 2016 11:15:04 -0400
Date: Mon, 13 Jun 2016 17:15:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: Use correct format specifier
Message-ID: <20160613151542.GA6205@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465661470-10525-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465661470-10525-1-git-send-email-xypron.glpk@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 11, 2016 at 06:11:10PM +0200, Heinrich Schuchardt wrote:
> Component mirror_num of struct btrfsic_block is defined
> as unsigned int. Use %u as format specifier.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: David Sterba <dsterba@suse.com>
