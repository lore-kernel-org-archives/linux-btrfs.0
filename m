Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbbI3QVc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 12:21:32 -0400
Date: Wed, 30 Sep 2015 18:20:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v3 1/2] btrfs-progs: Introduce warning and error for
 common use
Message-ID: <20150930162030.GM11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
 <58c06ee5bd98f3a92637eec20ecbc15f7abfa2ee.1443448527.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <58c06ee5bd98f3a92637eec20ecbc15f7abfa2ee.1443448527.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2015 at 09:58:13PM +0800, Zhao Lei wrote:
> And sometimes, we forgot add tailed '\n',

This is actually a good point and we don't need to put the trailing
newline to all the messages, similar to the btrfs_* macros used in
kernel. I'll update the patches.
