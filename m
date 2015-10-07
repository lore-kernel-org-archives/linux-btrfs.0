Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbbJGIz0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 04:55:26 -0400
Date: Wed, 7 Oct 2015 10:54:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing brelse when superblock checksum fails
Message-ID: <20151007085420.GC7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444035320-9400-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444035320-9400-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2015 at 04:55:20PM +0800, Anand Jain wrote:
> looks like oversight, call brelse() when checksum fails.
> further down the code in the non error path we do call
> brelse() and so we don't see brelse() in the goto error..
> paths.

Good catch. Please reformat the changelog to use the full 74 char line
and start sentences with capital letters.
