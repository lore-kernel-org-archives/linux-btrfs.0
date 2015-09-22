Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbbIVNFt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:05:49 -0400
Date: Tue, 22 Sep 2015 15:04:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: memset cur_trans->delayed_refs to zero
Message-ID: <20150922130454.GB12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150907142437.GA21090@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150907142437.GA21090@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 07, 2015 at 05:24:37PM +0300, Alexandru Moise wrote:
> Use memset() to null out the btrfs_delayed_ref_root of
> btrfs_transaction instead of setting all the members to 0 by hand.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Please use the versioning in patch subject so we know which version is
the latest, like

[PATCH v4] btrfs: memset cur_trans->delayed_refs to zero
