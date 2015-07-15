Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbbGOLdQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 07:33:16 -0400
Date: Wed, 15 Jul 2015 13:33:15 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Revert "btrfs-progs: mkfs: create only desired block
 groups for single device"
Message-ID: <20150715113314.GE6306@suse.cz>
Reply-To: dsterba@suse.com
References: <1436839981-20432-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150714114511.GG15535@twin.jikos.cz>
 <55A5AC0C.8080602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55A5AC0C.8080602@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 08:40:44AM +0800, Qu Wenruo wrote:
> BTW, for the mkfs test case, it will be delayed for a while as the 
> following bugs are making things quite tricky.

Good, thanks, no rush at the moment. The next release will be probably
in line with kernel 4.2 with the usual exception of important bugfixes.

> 1) fsck ignore chunk errors and return 0.
> Cause is known and easy to fix, but if fixed, most of fsck test won't pass.
> As the following bug is causing problem.
> 
> 2) btrfs-image restore bug, causing missing dev_extent for DUP chunk.
> Investigating. that's the reason causing a lot of dev extent missing in 
> mkfs test.

The image dumps may be intentionally incomplete so not all reported
errors are necessarily a problem. The restored filesystem should set the
METADUMP bit in the superblock so this can help.
