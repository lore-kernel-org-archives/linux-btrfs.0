Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab3DPK7U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 06:59:20 -0400
Date: Tue, 16 Apr 2013 12:59:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, Jan Schmidt <list.btrfs@jan-o-sch.net>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2 1/3] Btrfs: split btrfs_qgroup_account_ref into four
 functions
Message-ID: <20130416105918.GI18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1366101920-13083-2-git-send-email-list.btrfs@jan-o-sch.net>
 <516D17F1.4070208@cn.fujitsu.com>
 <516D1C25.5060103@jan-o-sch.net>
 <516D2035.6010800@cn.fujitsu.com>
 <20130416103228.GG18193@twin.jikos.cz>
 <516D2C33.1010601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516D2C33.1010601@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 06:47:15PM +0800, Wang Shilong wrote:
> I mean that other developers will get more information by the function name.

I don't dare to suggest putting a comment before the functions

david
