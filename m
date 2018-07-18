Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42618 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727083AbeGROiQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 10:38:16 -0400
Date: Wed, 18 Jul 2018 16:00:04 +0200
From: David Sterba <dsterba@suse.cz>
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] btrfs-progs: map-logical: Use
 btrfs_next_extent_item()
Message-ID: <20180718140004.GB26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+X5Wn4GAp9cLqCKUiu4H6PSAvi9e0quDsQOjarZbS5EDWmspA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+X5Wn4GAp9cLqCKUiu4H6PSAvi9e0quDsQOjarZbS5EDWmspA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2018 at 03:20:02AM -0400, james harvey wrote:
> btrfs_next_extent_item() looks for BTRFS_EXTENT_ITEM_KEY and BTRFS_METADATA_KEY,
> which are the types we're looking for.
> 
> Signed-off-by: James Harvey <jamespharvey20@gmail.com>

Applied, thanks.
