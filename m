Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbbCYByC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 21:54:02 -0400
Date: Wed, 25 Mar 2015 02:54:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Mike Gilbert <floppym@gentoo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix autoconf handling of --enable-convert
Message-ID: <20150325015400.GE20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427244941-3896-1-git-send-email-floppym@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427244941-3896-1-git-send-email-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 08:55:41PM -0400, Mike Gilbert wrote:
> AC_ARG_ENABLE(convert) sets $enable_convert, not $enable_btrfsconvert.
> 
> Signed-off-by: Mike Gilbert <floppym@gentoo.org>

Applied, thanks.
