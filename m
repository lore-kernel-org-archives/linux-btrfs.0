Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbaEPQlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 12:41:14 -0400
Date: Fri, 16 May 2014 18:41:12 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: add missing help option for rescue
 super-recover
Message-ID: <20140516164112.GD6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1400117349-2851-2-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140516163727.GC6917@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140516163727.GC6917@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 16, 2014 at 06:37:27PM +0200, David Sterba wrote:
> On Thu, May 15, 2014 at 09:29:08AM +0800, Gui Hecheng wrote:
> > Add '-h' option for help for super-recover,
> > update the manpage at the same time.
> 
> We don't have the short option for help, a few patches have been already
> rejected to change that.

Reference: https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30759.html
