Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab3H2MZ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 08:25:27 -0400
Date: Thu, 29 Aug 2013 14:25:23 +0200
From: David Sterba <dsterba@suse.cz>
To: lilofile <lilofile@aliyun.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: bug
Message-ID: <20130829122523.GG23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7c55ea3f-bb6d-4e77-8d2f-6368b437ed6a@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7c55ea3f-bb6d-4e77-8d2f-6368b437ed6a@aliyun.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 10:34:00AM +0800, lilofile wrote:
>  I made a btrfs on five disks using RAID5 (-d raid5 for mount option).
>  When a power failure occurs, I can not remount btrfs after my system
>  reboots. Dmesg for remount is presented as following:

Please note that current implementation of raid5/6 is not completely
crash-safe, as was mentioned in the announcement (eg. here
http://lwn.net/Articles/536038/). The mount could fail if the parity of
metadata blocks is corrupted due to crash.

david
