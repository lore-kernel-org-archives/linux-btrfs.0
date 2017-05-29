Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38021 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750886AbdE2RCC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 13:02:02 -0400
Date: Mon, 29 May 2017 19:01:01 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: test for restoring multiple devices fs
 into a single device
Message-ID: <20170529170101.GS14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170517014131.8549-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517014131.8549-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 02:41:31AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that we are able to create an image from a multiple devices fs, that
> we are able to restore that image into a single device and finally that we
> are able to mount it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Applied, with the shell quotes added, thanks.
