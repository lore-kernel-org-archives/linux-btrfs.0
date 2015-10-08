Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbbJHQhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 12:37:21 -0400
Date: Thu, 8 Oct 2015 18:36:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: restore: fix off-by-one len check
Message-ID: <20151008163613.GA27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444294029-23310-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1444294029-23310-1-git-send-email-vincent.stehle@freescale.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 08, 2015 at 10:47:09AM +0200, Vincent Stehlé wrote:
> Fix a check of len versus PATH_MAX in function copy_symlink(), to
> account for the terminating null byte.
> 
> Resolves-Coverity-CID: 1296749
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>

Applied, thanks.
