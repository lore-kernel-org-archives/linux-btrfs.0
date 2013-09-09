Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab3IIOWy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 10:22:54 -0400
Date: Mon, 9 Sep 2013 16:22:52 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs-progs:local variable memory freed
Message-ID: <20130909142252.GN32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1378348738-14451-3-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20130909141855.GM32382@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130909141855.GM32382@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 09, 2013 at 04:18:55PM +0200, David Sterba wrote:
> On Thu, Sep 05, 2013 at 10:38:55AM +0800, Gui Hecheng wrote:
> > The local probe variable in is_ssd() freed upon unsuccessful return;
> 
> FYI, I've applied a patch from Wang Shilong "Btrfs-progs: fix compile
> warning in is_ssd()" instead of the hunk below and will remove the
> respective changelog line. The rest of your patch stays.

Scratch that, the changes are not identical.
