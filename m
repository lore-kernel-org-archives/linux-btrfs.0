Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbcFFJCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 05:02:25 -0400
Date: Mon, 6 Jun 2016 11:01:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs-progs: convert-tests: Add support for
 custom test scripts
Message-ID: <20160606090143.GV29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160603023426.25216-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160603023426.25216-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 10:34:25AM +0800, Qu Wenruo wrote:
> Add support for custom convert test scripts, just like fsck tests.
> 
> Instead of generic convert tests, we need more specifically created images
> for new convert tests.
> 
> This patch provide the needed infrastructure for later convert test
> cases.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
