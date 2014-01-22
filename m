Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbaAVMoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 07:44:00 -0500
Date: Wed, 22 Jan 2014 13:43:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, Miao Xie <miaox@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Btrfs: fix protection between send and root
 deletion
Message-ID: <20140122124358.GI6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1389086721-19624-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20140113182745.GS6498@twin.jikos.cz>
 <52D49F80.6020604@cn.fujitsu.com>
 <20140115164038.GD6498@twin.jikos.cz>
 <52D744C6.7040006@cn.fujitsu.com>
 <20140121181626.GC6498@twin.jikos.cz>
 <52DF84DE.6080904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52DF84DE.6080904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 22, 2014 at 04:44:14PM +0800, Wang Shilong wrote:
> >So we disagree, I see a reason for the deletion protection and will do
> >the patch myself. Let's see if we can get more user feedback then.
> >
> >I'm NAKing this patch in current state, if it helps anything.
> Both ways are ok for me actually, don't be annoyed anyway,

Nah, this is a message to maintainers that the patch discussion has
reached some conclusion and should help deciding if the patch should be
merged or not. We've seen in the past that after a moderate discussion
against patch inclusion, the patch ended up merged as if nothing
happend. _This_ can be annoying.

> You and Miao are really doing a good job to Btrfs, just go ahead, i
> am ok with dropping this patch.^_^

Ok, thanks.
