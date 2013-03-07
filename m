Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab3CGRBp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 12:01:45 -0500
Date: Thu, 7 Mar 2013 09:00:59 -0800
From: Zach Brown <zab@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH] btrfs: enhance superblock checks
Message-ID: <20130307170059.GG3565@lenny.home.zabbo.net>
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
 <20130306185637.GE27710@lenny.home.zabbo.net>
 <20130307145253.GO21081@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130307145253.GO21081@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> What errno values do you suggest? For me it's 'checksum is correct:
> yes/no', hence return 1/0.

Oh, I have no strong preerence here.

> I see an -EIO below, but that does not seem right here. There's a call
> to btrfs_read_dev_super that would indicate an unreadable block. We
> could use EFSCORRUPTED as xfs does (with value of EUCLEAN = 117) though.
> 
> As implemented now, EINVAL will make 'mount' print the instructive
> message "look into the syslog", I'm not sure if we wouldn't need to
> update userspace to reflect the fine grained error codes.

Yeah, EINVAL seems reasonable.  mount(2):

       EINVAL source had an invalid superblock.

Documented (ish) and everything!

- z
