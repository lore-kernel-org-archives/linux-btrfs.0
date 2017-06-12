Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45591 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbdFLNDf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 09:03:35 -0400
Date: Mon, 12 Jun 2017 15:02:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: use ino_t for inode in tracer
Message-ID: <20170612130229.GH25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1497262228-729-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497262228-729-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 12, 2017 at 06:10:28PM +0800, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

There's one more in btrfs__qgroup_data_map, please fix it as well.
