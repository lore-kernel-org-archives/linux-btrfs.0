Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933341AbbJANFn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 09:05:43 -0400
Date: Thu, 1 Oct 2015 15:04:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 7/9] Btrfs: add free space tree sanity tests
Message-ID: <20151001130441.GC5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1443583874.git.osandov@osandov.com>
 <b8fbdc4c149cee8648399ebd985f111e4e4f191d.1443583874.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b8fbdc4c149cee8648399ebd985f111e4e4f191d.1443583874.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 08:50:36PM -0700, Omar Sandoval wrote:
> +struct free_space_extent {
> +	u64 start, length;

Structure members should be put on separate lines.
