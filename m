Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbbH1Rhp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 13:37:45 -0400
Date: Fri, 28 Aug 2015 19:37:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: progs: Unmount TEST_DEV before mount again
Message-ID: <20150828173707.GL11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <208f203f83cb0bef7d820e8b6b53fd69fc209514.1440733675.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <208f203f83cb0bef7d820e8b6b53fd69fc209514.1440733675.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 11:49:39AM +0800, Zhao Lei wrote:
> If a testcase failed, we can't run it(or other tests needs mount) again,

My expectation is that the testsuite will not fail and if it does, I
wan't to keep the last stat so I can have a look. Would it be acceptable
for you to enhance the clean-tests.sh script to unmount the TEST_DEV?

I've used loop devices in some tests, so possibly cleaning up those loop
devices after failed test could be put into clean-tests.sh as well.
