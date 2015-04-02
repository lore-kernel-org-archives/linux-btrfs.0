Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbbDBP0S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 11:26:18 -0400
Date: Thu, 2 Apr 2015 17:26:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs doc: emphasis that only mounted device works
 for btrfs device stats
Message-ID: <20150402152617.GL6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427874777-11871-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427874777-11871-1-git-send-email-chenhanxiao@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 01, 2015 at 03:52:57AM -0400, Chen Hanxiao wrote:
> We provided format <path>|<device> in command line.
> But btrfs device stats doesn't work if device is not mounted.

Although that's right, the dev stats are easy to implement in userspace.
Applied, as it reflects current state.
