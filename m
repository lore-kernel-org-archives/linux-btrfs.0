Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36872 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab2ITPuP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 11:50:15 -0400
Date: Thu, 20 Sep 2012 17:50:12 +0200
From: David Sterba <dave@jikos.cz>
To: Andrei Popa <andrei.popa@i-neo.ro>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make compress and nodatacow mount options
 mutually exclusive
Message-ID: <20120920155012.GS17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348152131-24198-1-git-send-email-andrei.popa@i-neo.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348152131-24198-1-git-send-email-andrei.popa@i-neo.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2012 at 05:42:11PM +0300, Andrei Popa wrote:
> If a filesystem is mounted with compression and then remounted by adding nodatacow,
> the compression is disabled but the compress flag is still visible.
> Also, if a filesystem is mounted with nodatacow and then remounted with compression,
> nodatacow flag is still present but it's not active.
> This patch:
> - removes compress flags and notifies that the compression has been disabled if the
>   filesystem is mounted with nodatacow
> - removes nodatacow and nodatasum flags if mounted with compress.
> 
> Signed-off-by: Andrei Popa <andrei.popa@i-neo.ro>

Reviewed-by: David Sterba <dsterba@suse.cz>
