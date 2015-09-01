Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbbIAJpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 05:45:22 -0400
Date: Tue, 1 Sep 2015 11:44:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] btrfs-progs: Update manual for new unit arguments
Message-ID: <20150901094442.GE11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441091348.git.zhaolei@cn.fujitsu.com>
 <630eb717ced2b912884ac55ecf76fe94ea3ef652.1441091348.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <630eb717ced2b912884ac55ecf76fe94ea3ef652.1441091348.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 01, 2015 at 03:12:07PM +0800, Zhao Lei wrote:
> We changed unit arguments for btrfs commands, this patch updated
> relative documents for them.

Sorry, I must have missed that in the previous patches, the point is not
to change the options. cmd_device_usage_usage should use th DF option
variant. I'll fix that.
