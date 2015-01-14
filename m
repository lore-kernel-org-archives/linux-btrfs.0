Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbbANRn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 12:43:27 -0500
Date: Wed, 14 Jan 2015 18:43:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] New btrfsck test framework
Message-ID: <20150114174325.GW3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419471135-10878-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 25, 2014 at 09:32:10AM +0800, Qu Wenruo wrote:
> This patchset introduce the new btrfsck test framework.

Thanks, merged to the 3.18.x branch, with the two patches and one
cosmetic adjustment to the output. The file layout seems flexible enough
to do what we may need in the future.
