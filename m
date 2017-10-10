Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755866AbdJJMLv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 08:11:51 -0400
Date: Tue, 10 Oct 2017 14:10:06 +0200
From: David Sterba <dsterba@suse.cz>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] btrfs: Use bd_dev to generate index when
 dev_state_hashtable add items.
Message-ID: <20171010121006.GK3521@suse.cz>
Reply-To: dsterba@suse.cz
References: <1506672995-12488-1-git-send-email-gujx@cn.fujitsu.com>
 <20170929180529.GW31640@twin.jikos.cz>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01479C859B@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01479C859B@G08CNEXMBPEKD02.g08.fujitsu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 09, 2017 at 01:54:14AM +0000, Gu, Jinxiang wrote:
> Hi,
> sorry for reply too late.
> 
> This patch fix for the bug descriped below.
> Use MOUNT_OPTIONS="-o check_int" when run xfstest, device
> Can not be mount successfully. So xfstest can not run.

So please update the changelog and resend. Thanks.
