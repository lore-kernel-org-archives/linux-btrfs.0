Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753927AbdHURVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:21:45 -0400
Date: Mon, 21 Aug 2017 19:20:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: add necessary close(fd) in mkfs
Message-ID: <20170821172020.GS2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 01:32:45AM -0700, Gu Jinxiang wrote:
> Add some close(fd) when error occures in mkfs.
> And add close(fd) when end use it.

Can you please rework it so all the in-place exists are gotos to a
common exit block that does the close(fd) cleanup? Thanks.
