Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaH2Otj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 10:49:39 -0400
Date: Fri, 29 Aug 2014 16:49:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: remove meaningless debug info for
 restore
Message-ID: <20140829144937.GE31801@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1409192755-1826-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1409192755-1826-3-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409192755-1826-3-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 28, 2014 at 10:25:55AM +0800, Gui Hecheng wrote:
> The printf of @offset enlightens the user little.
> And the restore cmd is not a debugging tool, so just
> remove the debug-info-like printf.

I'd like to let the restore command be more verbose as it's potentially
working with a broken filesystem and getting details can help. There's
-v option for increasing verbosity, please move the printf there.

Thaks.
