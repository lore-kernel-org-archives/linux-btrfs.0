Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15362 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056AbaGDCCb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 22:02:31 -0400
Message-ID: <1404439026.22279.8.camel@localhost.localdomain>
Subject: Re: [PATCH] btrfs-progs: add mount status check for btrfs-image
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Fri, 4 Jul 2014 09:57:06 +0800
In-Reply-To: <20140703165818.GH1553@twin.jikos.cz>
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1404353196-10914-2-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140703165818.GH1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-07-03 at 18:58 +0200, David Sterba wrote:
> On Thu, Jul 03, 2014 at 10:06:34AM +0800, Gui Hecheng wrote:
> > The btrfs-image tool should not be run on a mounted filesystem.
> 
> Should not, but for some values of "sometimes" it makes sense, eg.
> capturing image of an otherwise quiescent filesystem, a read-only mount
> or after a crash.

Ah, read-only mount is really a case.

> This utility is used for debugging so I'd prefer to let the user do as
> he likes, though printing the warning about the mount status is a good
> improvement.

I agree, then I'll keep the check_mounted and just give a prompt and let
it continue.

> > The undergoing fs operations may change what you have imaged a while ago,
> > this makes the image meanmingless.
> 
> I'm not familiar with the image format, but maybe we can set a bit in
> the header when the filesystem was not captured cleanly.

Hmm...This is a point, I think I'll give it a try in another patch.


