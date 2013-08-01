Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3HAWBj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 18:01:39 -0400
Date: Thu, 1 Aug 2013 15:01:37 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add dedup subcommand
Message-ID: <20130801220137.GB31381@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com> <1375285066-14173-7-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375285066-14173-7-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 11:37:46PM +0800, Liu Bo wrote:
> This aims to add deduplication subcommand, 'btrfs dedup command <path>',
> ie. register/unregister'.
> 
> It can be used to enable or disable dedup support for a filesystem.

This seems to me like it should be a switch on btrfstune instead of a
subcommand of the btrfs binary.
	--Mark

--
Mark Fasheh
