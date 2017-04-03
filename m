Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdDCMHY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Apr 2017 08:07:24 -0400
Date: Mon, 3 Apr 2017 14:06:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: delete unused member nobarriers
Message-ID: <20170403120639.GS4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170331112608.32478-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170331112608.32478-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please update the changelog to say why it's ok to remove it, eg. the
commit that removed the last user.

commit b25de9d6da49b1a8760a89672283128aa8c78345
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Apr 24 21:41:01 2015 +0200

    block: remove BIO_EOPNOTSUPP

Otherwise the patch is ok.
