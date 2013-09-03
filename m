Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab3ICSTr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 14:19:47 -0400
Date: Tue, 3 Sep 2013 11:19:45 -0700
From: Zach Brown <zab@redhat.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: more efficient inode tree replace operation
Message-ID: <20130903181945.GY26818@lenny.home.zabbo.net>
References: <1378120753-21061-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378120753-21061-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 02, 2013 at 12:19:13PM +0100, Filipe David Borba Manana wrote:
> Instead of removing the current inode from the red black tree
> and then add the new one, just use the red black tree replace
> operation, which is more efficient.

Yup, this looks correct to me.

Reviewed-by: Zach Brown <zab@redhat.com>

- z
