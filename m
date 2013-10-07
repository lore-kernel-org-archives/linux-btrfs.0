Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab3JGV5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:57:37 -0400
Date: Mon, 7 Oct 2013 14:57:35 -0700
From: Zach Brown <zab@redhat.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unnecessary key copy when logging inode
Message-ID: <20131007215735.GH25712@lenny.home.zabbo.net>
References: <1381177244-8613-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381177244-8613-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 09:20:44PM +0100, Filipe David Borba Manana wrote:
> The btrfs_insert_empty_item() function doesn't modify its
> key argument.

Looks reasonable to me.

Reviewed-by: Zach Brown <zab@redhat.com>

- z
