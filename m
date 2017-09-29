Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43441 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752162AbdI2SHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 14:07:04 -0400
Date: Fri, 29 Sep 2017 20:05:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] btrfs: Use bd_dev to generate index when
 dev_state_hashtable add items.
Message-ID: <20170929180529.GW31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506672995-12488-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506672995-12488-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 04:16:35PM +0800, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> Fix bug of
> <f8f84b2dfda5> (<btrfs: index check-integrity state hash by a dev_t>).

Please explain what bug are you fixing.
