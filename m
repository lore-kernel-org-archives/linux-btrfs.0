Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754329AbdHURYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:24:54 -0400
Date: Mon, 21 Aug 2017 19:23:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: delete not-used parameter fd
Message-ID: <20170821172329.GT2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
 <1503045166-18612-2-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503045166-18612-2-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 01:32:46AM -0700, Gu Jinxiang wrote:
> Parameter fd is not used in function make_image and
> traverse_directory of mkfs.
> Delete it.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Apparently the parameter has never been used. Applied, thanks.
