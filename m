Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3JHPJe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 11:09:34 -0400
Date: Tue, 8 Oct 2013 17:08:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 03/12] Btrfs-progs: introduces '-c' option to print
 the ID of the child qgroups
Message-ID: <20131008150852.GD4322@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1381130508-8458-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381130508-8458-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 03:21:39PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> This patch introduces '-c' option to print the ID of the child qgroups.
> You may use it like:
> 	btrfs qgroup show -c <path>

I haven't looked closely, but using -c leads probably to a infinite loop
somewhere. The screen scrolls away quickly filled with spaces after it
prints the table:

qgroupid rfer        excl        child
-------- ----        ----        -----
0/5      921600      921600      ---
0/267    704512      12288       ---
0/268    700416      8192        ---
0/269    7206805504  4096        ---
0/277    7206805504  4096        ---
0/278    36884398080 36884398080 ---
1/1      7206809600  7206809600  0/269,0/277
