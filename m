Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbbHZPRB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 11:17:01 -0400
Date: Wed, 26 Aug 2015 17:16:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: remove code for setup mntid in
 cmd_subvol_show
Message-ID: <20150826151624.GZ10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <88362f08a12bcf5c094b57cca9424ef5438e3605.1440598568.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <88362f08a12bcf5c094b57cca9424ef5438e3605.1440598568.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:16:14PM +0800, Zhao Lei wrote:
> We don't need to use value of mntid in cmd_subvol_show(), no need
> to get its value.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Right, the subvolume id is obtained by other means. Applied, thanks.
