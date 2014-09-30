Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:49290 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaI3PYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 11:24:46 -0400
Date: Tue, 30 Sep 2014 08:24:46 -0700
From: Zach Brown <zab@zabbo.net>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Don't return any fs_info that contain NULL
 tree_root or fs_root.
Message-ID: <20140930152446.GB12900@lenny.home.zabbo.net>
References: <1412044762-2480-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140930113556.GI11436@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140930113556.GI11436@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> btrfs_setup_all_roots(). Please test if it fixes the crash with the
> corrupted image you have. Thanks.

Perhaps with a test in xfstests.

- z
