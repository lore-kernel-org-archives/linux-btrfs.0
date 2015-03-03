Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbbCCOiT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 09:38:19 -0500
Date: Tue, 3 Mar 2015 15:38:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs:__add_inode_ref: out of bounds memory read when
 looking for extended ref.
Message-ID: <20150303143817.GO8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1424966437-29795-1-git-send-email-quentin.casasnovas@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424966437-29795-1-git-send-email-quentin.casasnovas@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adding linux-btrfs to CC

On Thu, Feb 26, 2015 at 05:00:37PM +0100, Quentin Casasnovas wrote:
> Improper arithmetics when calculting the address of the extended ref could
> lead to an out of bounds memory read and kernel panic.
> 
> Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>

Good catch.

CC: <stable@vger.kernel.org>
Reviewed-by: David Sterba <dsterba@suse.cz>
