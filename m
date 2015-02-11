Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbbBKSIX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 13:08:23 -0500
Date: Wed, 11 Feb 2015 19:08:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Fix 2 extent buffer leak in
 btrfs-debug-tree.
Message-ID: <20150211180822.GH28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423619837-24073-1-git-send-email-quwenruo@cn.fujitsu.com>
 <54DAB826.9010400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54DAB826.9010400@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 10:02:14AM +0800, Qu Wenruo wrote:
> > There are 2 known extent buffer:
> Oh, a small typo: "2 known extent buffer leak:", missing the word leak.

Fixed and applied, thanks.
