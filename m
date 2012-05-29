Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36311 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2E2LT2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 07:19:28 -0400
Date: Tue, 29 May 2012 13:18:33 +0200
From: David Sterba <dave@jikos.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: bruce@untroubled.org, linux-btrfs@vger.kernel.org
Subject: Re: Make existing snapshots read-only?
Message-ID: <20120529111833.GU24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120528183700.GA9588@untroubled.org>
 <4FC41AEA.2040905@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC41AEA.2040905@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2012 at 08:40:10AM +0800, Li Zefan wrote:
> > Is there any way to mark existing snapshots as read-only? Making new
> > ones read-only is easy enough, but what about existing ones?
> 
> We have code in the kernel side, so what we need to do is to update btrfs-progs,
> which is trivial.

Well, I don't like that it's even possible to turn a RO snapshot to a RW
one. What was the rationale behind this back then? Besides, I think that
it could break assumptions in the backref code.

If it's only a one-way operation from a regular subvol -> RO subvol,
this sounds reasonable to me. If the opposite direction is allowed, then
I'd not call it 'read-only' but "unwritable on-request".


david
