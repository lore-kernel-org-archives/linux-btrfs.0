Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbbGNPi0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 11:38:26 -0400
Date: Tue, 14 Jul 2015 17:38:24 +0200
From: David Sterba <dsterba@suse.com>
To: Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Documentation: update btrfs-replace manual to support
 RAID5/6
Message-ID: <20150714153824.GA6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1436235136-25282-1-git-send-email-wangyf-fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436235136-25282-1-git-send-email-wangyf-fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 07, 2015 at 10:12:16AM +0800, Wang Yanfeng wrote:
> Man manual need to be updated since RAID5/6 has been supported
> by btrfs-replace.
> 
> Signed-off-by: Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>

Applied, thanks. Please do not forget to add 'btrfs-progs' into the subject
otherwise, I might miss progs patches while skimming the mailinglist and
delay merging unnecessarily.
