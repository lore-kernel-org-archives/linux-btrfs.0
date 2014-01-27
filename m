Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaA0QwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 11:52:18 -0500
Date: Mon, 27 Jan 2014 17:52:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: add a reschedule point in btrfs_find_all_roots()
Message-ID: <20140127165217.GY6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390746738-7500-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390746738-7500-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 26, 2014 at 10:32:18PM +0800, Wang Shilong wrote:
> I can easily trigger the following warnings when enabling quota
> in my virtual machine(running Opensuse), Steps are firstly creating
> a subvolume full of fragment extents, and then create many snapshots
> (500 in my test case).

Good one.  You can try to increase the stress and find more of such
stalls, any while() loop using qgroups inside is a good candidate.
Sometimes the scheduling points are implied by called functions.

> Cc: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
