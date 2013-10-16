Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934511Ab3JPSOJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 14:14:09 -0400
Date: Wed, 16 Oct 2013 11:14:06 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: stop all workers after we free block groups
Message-ID: <20131016181406.GO11338@lenny.home.zabbo.net>
References: <1381946210-12656-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381946210-12656-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 16, 2013 at 01:56:50PM -0400, Josef Bacik wrote:
> Stefan was hitting a panic in the async worker stuff because we had outstanding
> read bios while we were stopping the worker threads.

>  fs/btrfs/disk-io.c | 4 ++--

Seems like a nice candidate for stable@, no?

- z
