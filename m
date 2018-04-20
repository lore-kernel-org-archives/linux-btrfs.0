Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752351AbeDTNHX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 09:07:23 -0400
Date: Fri, 20 Apr 2018 15:04:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
Message-ID: <20180420130450.GQ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180419093816.888-1-wqu@suse.com>
 <7e7554c2-28d1-5912-7f02-e1f87556a3a8@suse.com>
 <b94eaf2e-8d5e-23e9-0672-2eb5abd56ae8@gmx.com>
 <20180419153106.GJ21272@twin.jikos.cz>
 <17216718-a88d-de20-1a26-e7a5a515d02a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <17216718-a88d-de20-1a26-e7a5a515d02a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 07:24:48PM +0300, Nikolay Borisov wrote:
> I agree with David, just make it btrfs_validate_super

Ack.
