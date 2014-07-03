Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaGCQ6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 12:58:20 -0400
Date: Thu, 3 Jul 2014 18:58:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add mount status check for btrfs-image
Message-ID: <20140703165818.GH1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1404353196-10914-2-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404353196-10914-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 10:06:34AM +0800, Gui Hecheng wrote:
> The btrfs-image tool should not be run on a mounted filesystem.

Should not, but for some values of "sometimes" it makes sense, eg.
capturing image of an otherwise quiescent filesystem, a read-only mount
or after a crash.

This utility is used for debugging so I'd prefer to let the user do as
he likes, though printing the warning about the mount status is a good
improvement.

> The undergoing fs operations may change what you have imaged a while ago,
> this makes the image meanmingless.

I'm not familiar with the image format, but maybe we can set a bit in
the header when the filesystem was not captured cleanly.
