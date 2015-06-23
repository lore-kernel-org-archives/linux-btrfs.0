Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630AbbFWMAV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 08:00:21 -0400
Date: Tue, 23 Jun 2015 14:00:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Maninder Singh <maninder1.s@samsung.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, pankaj.m@samsung.com
Subject: Re: [PATCH 1/1] Btrfs: Remove redundant NULL check before kfree
Message-ID: <20150623120017.GZ6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <1435039080-2952-1-git-send-email-maninder1.s@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435039080-2952-1-git-send-email-maninder1.s@samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 11:28:00AM +0530, Maninder Singh wrote:
> There is no need of NULL check before kfree,
> removing the same
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Reviewed-by: Akhilesh Kumar <akhilesh.k@samsung.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
