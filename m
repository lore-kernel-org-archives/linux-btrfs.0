Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43551 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965714AbcIWN2G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 09:28:06 -0400
Date: Fri, 23 Sep 2016 15:26:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, hawken@thehawken.org
Subject: Re: [PATCH 2/2] btrfs-progs: super-recover: Reuse
 btrfs_read_dev_super function
Message-ID: <20160923132603.GZ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160920021902.818-1-quwenruo@cn.fujitsu.com>
 <20160920021902.818-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920021902.818-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:19:02AM +0800, Qu Wenruo wrote:
> We have enhanced super block validation check in disk_io.c, while
> super-recover doesn't use that function and use a custom one.
> 
> That is duplicated, so reuse btrfs_read_dev_super to handle it, which
> not only enhanced super check, but also reduce the code length.

Yeah, the existing check_super does way more checks compared to this
one. Applied, thanks.
