Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38020 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3A1TUz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 14:20:55 -0500
Date: Mon, 28 Jan 2013 11:20:54 -0800
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not merge logged extents if we've removed them
 from the tree
Message-ID: <20130128192054.GO14246@lenny.home.zabbo.net>
References: <1359384776-2107-1-git-send-email-jbacik@fusionio.com>
 <20130128185226.GM14246@lenny.home.zabbo.net>
 <20130128191941.GF3257@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130128191941.GF3257@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'll fix the commit message, we just add something to the tree that doesn't have
> a ref so it's a basic use after free sort of scenario. Thanks,

Thanks, complete commit messages help us old farts keep up.

- z
