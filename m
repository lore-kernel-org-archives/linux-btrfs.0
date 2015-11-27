Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbbK0IdT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 03:33:19 -0500
Date: Fri, 27 Nov 2015 09:31:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use kbasename in btrfsic_mount
Message-ID: <20151127083131.GW31035@suse.cz>
Reply-To: dsterba@suse.cz
References: <1448611892-26144-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448611892-26144-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 09:11:31AM +0100, Rasmus Villemoes wrote:
> This is more readable.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: David Sterba <dsterba@suse.com>
