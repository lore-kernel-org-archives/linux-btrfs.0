Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161499AbcE3P5d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 11:57:33 -0400
Date: Mon, 30 May 2016 17:56:56 +0200
From: David Sterba <dsterba@suse.cz>
To: quwenruo@cn.fujitsu.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: run rollback after conversion
Message-ID: <20160530155656.GD29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464623554-5119-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464623554-5119-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

the convert patchset does not pass a rollback test, fails in the case of
32k nodesize. Thre's not much info why, just 'rollback failed'.

The branch that passes is 'test-rollback', it's current devel without
the convert and low-mem fsck patchsets.
