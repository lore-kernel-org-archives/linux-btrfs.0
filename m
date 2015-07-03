Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbbGCQG2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jul 2015 12:06:28 -0400
Date: Fri, 3 Jul 2015 18:06:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfsck repair for I_ERR_FILE_WRONG_NBYTES and test
 case
Message-ID: <20150703160627.GQ726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1435819951-16933-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1435819951-16933-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435819951-16933-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 02, 2015 at 02:52:31PM +0800, Qu Wenruo wrote:
> Add repair function for I_ERR_FILE_WRONG_NBYTES and a test case for it.
> Rebased to devel branch.
> 
> The second patch contains binary data, so created a pull request for it.
> https://github.com/kdave/btrfs-progs/pull/7
> 
> Qu Wenruo (2):
>   btrfs-progs: fsck:Add repair function for I_ERR_FILE_WRONG_NBYTES.
>   btrfs-progs: tests: Add test case for I_ERR_FILE_WRONG_NBYTES repair.

Applied, thanks.
