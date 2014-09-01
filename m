Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2977 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbaIABgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 21:36:41 -0400
Message-ID: <1409535309.8843.2.camel@localhost.localdomain>
Subject: Re: [PATCH 3/3] btrfs-progs: remove meaningless debug info for
 restore
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Mon, 1 Sep 2014 09:35:09 +0800
In-Reply-To: <20140829144937.GE31801@twin.jikos.cz>
References: <1409192755-1826-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1409192755-1826-3-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140829144937.GE31801@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-08-29 at 16:49 +0200, David Sterba wrote:
> On Thu, Aug 28, 2014 at 10:25:55AM +0800, Gui Hecheng wrote:
> > The printf of @offset enlightens the user little.
> > And the restore cmd is not a debugging tool, so just
> > remove the debug-info-like printf.
> 
> I'd like to let the restore command be more verbose as it's potentially
> working with a broken filesystem and getting details can help. There's
> -v option for increasing verbosity, please move the printf there.

OK，since the -v option seems to serve as a debug helper.

> Thaks.


