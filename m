Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab3HEREV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 13:04:21 -0400
Date: Mon, 5 Aug 2013 19:04:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 06/11] btrfs-progs: scan /dev/mapper in filesystem show
 and device scan
Message-ID: <20130805170419.GE5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373866257-10519-7-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
 <1373866257-10519-7-git-send-email-anand.jain@oracle.com>

On Mon, Jul 15, 2013 at 01:30:52PM +0800, Anand Jain wrote:
> This patch adds --mapper option to btrfs device scan and
> btrfs filesystem show cli, when used will look for btrfs
> devs under /dev/mapper and will use the links provided
> under the /dev/mapper.

> In the long run I want the usage of /dev/mapper path
> (along with /proc/partitions) be the default option to
> scan for the btrfs devs. (/proc/partitions must be scanned
> as well because to include the mapper blacklisted devs.)

Well, we want to avoid using own scanning and always consult the blkid
cache, so I'd rather stop adding user-visible changes to this command.

david
