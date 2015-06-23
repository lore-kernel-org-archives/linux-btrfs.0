Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbbFWO74 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 10:59:56 -0400
Date: Tue, 23 Jun 2015 16:59:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: allow dedupe of same inode
Message-ID: <20150623145955.GH6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435013262-23252-1-git-send-email-mfasheh@suse.de>
 <1435013262-23252-5-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435013262-23252-5-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 03:47:41PM -0700, Mark Fasheh wrote:
> clone() supports cloning within an inode so extent-same can do
> the same now. This patch fixes up the locking in extent-same to
> know about the single-inode case. In addition to that, we add a
> check for overlapping ranges, which clone does not allow.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Reviewed-by: David Sterba <dsterba@suse.cz>
