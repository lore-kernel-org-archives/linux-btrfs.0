Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210AbbFVOI1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 10:08:27 -0400
Date: Mon, 22 Jun 2015 16:08:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] Btrfs: Check if kobject is initialized before put
Message-ID: <20150622140825.GT6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434968312-16463-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434968312-16463-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 22, 2015 at 06:18:32PM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Tested-by: David Sterba <dsterba@suse.cz>

Thanks, fixes the crash in the sysfs update patchset.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
