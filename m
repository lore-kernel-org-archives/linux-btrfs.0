Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbIGKcH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Sep 2015 06:32:07 -0400
Date: Mon, 7 Sep 2015 18:32:04 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: add regression test for a btrfs enospc issue
Message-ID: <20150907103204.GD18060@dhcp-13-216.nay.redhat.com>
References: <1441620566-10624-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441620566-10624-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 07, 2015 at 11:09:26AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Regression test for an ENOSPC issue when attempting to write to a file in
> a filesystem without any data block groups allocated.
> 
> The btrfs issue is fixed by the linux kernel patch titled
> "Btrfs: don't initialize a space info as full to prevent ENOSPC" and the
> regression was introduced by the patch titled
> "Btrfs: fix block group ->space_info null pointer dereference".
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>
