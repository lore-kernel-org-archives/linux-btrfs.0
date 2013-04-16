Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab3DPKcb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 06:32:31 -0400
Date: Tue, 16 Apr 2013 12:32:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2 1/3] Btrfs: split btrfs_qgroup_account_ref into four
 functions
Message-ID: <20130416103228.GG18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1366101920-13083-2-git-send-email-list.btrfs@jan-o-sch.net>
 <516D17F1.4070208@cn.fujitsu.com>
 <516D1C25.5060103@jan-o-sch.net>
 <516D2035.6010800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516D2035.6010800@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 05:56:05PM +0800, Wang Shilong wrote:
> But static checker may want to know what is 3 steps
> just by the function name but not to read the pdf.

I'm curious what static checker you mean and how a function name helps
there.

thanks,
david
