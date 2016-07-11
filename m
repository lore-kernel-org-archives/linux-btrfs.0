Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbcGKK2C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 06:28:02 -0400
Date: Mon, 11 Jul 2016 12:28:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs-progs: dedupe-inband enable/reconfigure: force
 option does not take argument
Message-ID: <20160711102808.GU13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3042cdcf-7a4a-4524-2b4f-af24f5a8b42f@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3042cdcf-7a4a-4524-2b4f-af24f5a8b42f@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 08, 2016 at 03:11:42PM +0900, Satoru Takeuchi wrote:
> ---
> This patch can be applied to integration-20160704(2355a7e5dcdf122d1924)

I will not apply this separately, this should be folded to the proper
patchset.
