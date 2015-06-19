Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbbFSK0R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 06:26:17 -0400
Date: Fri, 19 Jun 2015 12:26:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.1-rc1: btrfstune -u reporting incorrect current
 fsid?
Message-ID: <20150619102615.GK6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAMU1PDjKbbXPrr5uPgPUEzfN+RWxi9McvRLS02N7N9JJ39q2ug@mail.gmail.com>
 <20150618173332.GJ6761@twin.jikos.cz>
 <55837315.90109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55837315.90109@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 09:40:37AM +0800, Qu Wenruo wrote:
> Just a little tip to take less time on the bug:
> -       uuid_parse((const char*)fs_info->fsid, old_fsid);
> +       memcpy(old_fsid, fs_info->fsid, BTRFS_UUID_SIZE);

Thanks, that's what I did.
