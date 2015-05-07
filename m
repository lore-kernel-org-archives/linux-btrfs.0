Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbbEGQTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 12:19:45 -0400
Date: Thu, 7 May 2015 18:19:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] Btrfs: fix race when reusing stale extent buffers that
 leads to BUG_ON
Message-ID: <20150507161944.GF23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429784928-12665-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429784928-12665-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 11:28:48AM +0100, Filipe Manana wrote:
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Phew, great catch and fix.

Reviewed-by: David Sterba <dsterba@suse.cz>

Chis, please try to squeeze it into 4.1-rc.
