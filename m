Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbbGNLpN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 07:45:13 -0400
Date: Tue, 14 Jul 2015 13:45:11 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Revert "btrfs-progs: mkfs: create only desired block
 groups for single device"
Message-ID: <20150714114511.GG15535@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1436839981-20432-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436839981-20432-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 14, 2015 at 10:13:01AM +0800, Qu Wenruo wrote:
> This reverts commit 5f8232e5c8f0b0de0ef426274911385b0e877392.

Thanks.  The revert is justified for the severity of the problem, I'll
release 4.1.2 asap.

> This commit causes a regression:
> ---

BTW, do not use --- in the changelog as 'git am' will ignore the text
between that and the diff.
