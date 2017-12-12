Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42620 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752279AbdLLRfL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 12:35:11 -0500
Date: Tue, 12 Dec 2017 18:33:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: do not merge rbios if their fail stripe index
 are not identical
Message-ID: <20171212173308.GM3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171211215631.27546-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171211215631.27546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 11, 2017 at 02:56:31PM -0700, Liu Bo wrote:
> Since fail stripe index in rbio would be used to decide which
> algorithm reconstruction would be run, we cannot merge rbios if
> their's fail striped index are different, otherwise, one of the two
> reconstructions would fail.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Patch replaced in the branch.
