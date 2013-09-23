Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab3IWMK0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 08:10:26 -0400
Date: Mon, 23 Sep 2013 14:10:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: [offlist] Re: [PATCH 4/4] Btrfs-progs: add super-recover to recover
 bad supers
Message-ID: <20130923121023.GM6810@suse.cz>
Reply-To: dsterba@suse.cz
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1379492856-30639-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20130918151304.GD6810@twin.jikos.cz>
 <936776EC-7D7D-458F-960E-E1CB56F9B4BA@gmail.com>
 <20130918163127.GF6810@twin.jikos.cz>
 <0223DF74-26DE-44A2-8D5B-1B7DC1879940@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0223DF74-26DE-44A2-8D5B-1B7DC1879940@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 21, 2013 at 09:16:25AM +0800, Wang Shilong wrote:
> > - open_ctree_fs_info_restore(target, 0, 0, 0, 1);
> > + open_ctree_fs_info_restore(target, 0, 0, OPEN_CTREE_PARTIAL);
> 
> Good idea, i think this should be another patch. 

yes
