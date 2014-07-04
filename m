Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaGDPVm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 11:21:42 -0400
Date: Fri, 4 Jul 2014 17:21:40 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs-progs: Add minimum device size check
Message-ID: <20140704152140.GQ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404458957-23621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140704141746.GP1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140704141746.GP1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 04:17:46PM +0200, David Sterba wrote:
> On Fri, Jul 04, 2014 at 03:29:17PM +0800, Qu Wenruo wrote:
> > v4: Fix a variant reuse bug which causes mkfs.btrfs use wrong first device.
> 
> Can you please send this incremental change only? The v3 patch is deep
> in the v3.15.x branch that's supposed to comprise patches for the 3.15
> release. The diff between v3 and v4 is pretty small, such mistakes
> happen, no big deal (unlike rebasing a branch that was public for some
> time already).

Oh crap, I left my note in subject of the v3 patch in git. I'd rather
not let it to the final branch, but the rebase is be necessary.
Sorry. I'll take v4 then.
