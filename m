Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbbGNRde (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 13:33:34 -0400
Date: Tue, 14 Jul 2015 19:33:32 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 7/7] btrfs-progs: mkfs: Cleanup temporary chunk to avoid
 strange balance behavior.
Message-ID: <20150714173332.GC6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1436256928-23812-8-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436256928-23812-8-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 07, 2015 at 04:15:28PM +0800, Qu Wenruo wrote:
[...]
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks a lot. I've tested several data/metadata combinations
and the resulting 'fi df' looks ok.
