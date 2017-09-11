Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751015AbdIKS7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 14:59:31 -0400
Date: Mon, 11 Sep 2017 20:58:00 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: update btrfs-completion
Message-ID: <20170911185800.GB14538@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b5719816-3e51-e3fa-454c-f0da71bfe75d@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b5719816-3e51-e3fa-454c-f0da71bfe75d@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 11, 2017 at 02:22:43PM +0900, Misono, Tomohiro wrote:
> This patch updates btrfs-completion:
>  - add "filesystem du" and "rescure zero-log"
>  - restrict _btrfs_mnts to show btrfs type only
>  - add more completion in last case statements
> 
> (This file contains both spaces/tabs and may need cleanup.)
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied, thanks. Feel free to send the whitespace cleanup patch.
