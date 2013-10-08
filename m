Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab3JHPez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 11:34:55 -0400
Date: Tue, 8 Oct 2013 17:34:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 10/12] Btrfs-progs: add '--block-size' option to
 control print result
Message-ID: <20131008153439.GE4322@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 03:21:46PM +0800, Wang Shilong wrote:
> You can use it like:
> 	btrfs qgroup show --block-size=m <mnt>
> 
> Here, block size supports k/K/m/M/g/G/t/T/p/P/e/E.

There is no distinction between the 1000 and 1024 based prefixes, also
no way to get the raw values in bytes. I don't have a suggestion how to
do that, merely letting you know that this could go separately (this and
the "-h" patch, the rest shall be integrated).

Also, the numbers in the table should be aligned to the right:

$ btrfs qgroup show -h -p /mnt/
qgroupid rfer      excl      parent
-------- ----      ----      ------
0/5      900.00KiB 900.00KiB ---
0/267    688.00KiB 12.00KiB  1/5
0/268    684.00KiB 8.00KiB   1/5
0/269    6.71GiB   4.00KiB   1/1
0/277    6.71GiB   4.00KiB   1/1
0/278    39.74GiB  39.74GiB  1/2
1/1      6.71GiB   6.71GiB   ---
1/2      39.74GiB  39.74GiB  ---
1/5      696.00KiB 696.00KiB ---


david
