Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaEPPuA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 11:50:00 -0400
Date: Fri, 16 May 2014 17:49:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fsck: add an option to check data csums
Message-ID: <20140516154959.GA6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399512409-661-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <536B610B.9070909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <536B610B.9070909@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 01:48:43PM +0300, Konstantinos Skarlatos wrote:
> On 8/5/2014 4:26 πμ, Wang Shilong wrote:
> >This patch adds an option '--check-data-csum' to verify data csums.
> >fsck won't check data csums unless users specify this option explictly.
> Can this option be added to btrfs restore as well? i think it would be a
> good thing if users can tell restore to only recover non-corrupt files.

Good idea. From the UI side, I think about adding 3 option variants:

* restore all (default)
* restore only files with completely valid checksums
* dtto invalid checksums

The point is to efficiently retrieve files based on their validity, so
without the 3rd option, one would have to "subtract" 2 from 1.
