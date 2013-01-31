Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:38108 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab3AaUXm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 15:23:42 -0500
Date: Thu, 31 Jan 2013 12:23:41 -0800
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix freeing delayed ref head while still holding
 its mutex V2
Message-ID: <20130131202341.GH14246@lenny.home.zabbo.net>
References: <1359650115-12743-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359650115-12743-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> V1->V2: don't duplicate the freeing stuff, just unlock if we have a head.

Nice, that's what I was picturing if we needed the freeing stuff to be
covered by the mutex.  Thanks for cleaning it up.

- z
