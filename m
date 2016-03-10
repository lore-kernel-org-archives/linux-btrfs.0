Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbcCJNhG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 08:37:06 -0500
Date: Thu, 10 Mar 2016 14:36:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: Describe device scan -d is a deprecated
 option in manpage
Message-ID: <20160310133644.GH18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E0AC1B.3020405@jp.fujitsu.com>
 <56E0ACEF.5050701@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E0ACEF.5050701@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 08:08:31AM +0900, Satoru Takeuchi wrote:
> It's already marked as deprecated in cmd_device_scan_usage().
> 
> commit 5444864e5605 ("btrfs-progs: remove BTRFS_SCAN_PROC scan method")
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, thanks.
