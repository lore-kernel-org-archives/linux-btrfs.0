Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38578 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754136AbaG3BX0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 21:23:26 -0400
Message-ID: <1406683056.27474.1.camel@localhost.localdomain>
Subject: Re: [PATCH 3/4] btrfs-progs: replace a confusing raw number with a
 macro
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 30 Jul 2014 09:17:36 +0800
In-Reply-To: <20140729121902.GP1553@twin.jikos.cz>
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1405564839-28702-3-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140729121614.GO1553@twin.jikos.cz> <20140729121902.GP1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-07-29 at 14:19 +0200, David Sterba wrote:
> On Tue, Jul 29, 2014 at 02:16:14PM +0200, David Sterba wrote:
> > On Thu, Jul 17, 2014 at 10:40:38AM +0800, Gui Hecheng wrote:
> > > The raw number 36 for the uuid string length is somewhat confusing,
> > > use a macro to define replace it.
> > 
> > There's the BTRFS_UUID_UNPARSED_SIZE macro, please use it instead to
> > avoid duplicate definitions.
> 
> Or I'll do that myself as it's a really a small change.
Oh, yes, it is really kind of you to do so :)


