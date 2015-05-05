Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993421AbbEEPiS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 11:38:18 -0400
Date: Tue, 5 May 2015 17:38:16 +0200
From: David Sterba <dsterba@suse.cz>
To: xuw2015@gmail.com
Cc: linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [PATCH 2/3] btrfs: support to find missing device by path
Message-ID: <20150505153816.GJ5099@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
 <1430384845-9666-2-git-send-email-xuw2015@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430384845-9666-2-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 30, 2015 at 05:07:24PM +0800, xuw2015@gmail.com wrote:
> From: George Wang <xuw2015@gmail.com>
> 
> First try to find the device matches specified device path, if nothing, then
> find the device by (devid, dev_uuid). This can fix the regression for
> replacing an offline device which path is held in btrfs_device.

I vaguely remember similar patches sent by Anand, CCed.
