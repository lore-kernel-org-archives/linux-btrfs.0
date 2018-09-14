Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48426 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726902AbeINTto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:49:44 -0400
Date: Fri, 14 Sep 2018 16:34:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: change filename limit to 255 when creating
 subvolume
Message-ID: <20180914143456.GL5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180912073903.10134-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180912073903.10134-1-suyj.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 03:39:03PM +0800, Su Yanjun wrote:
> Modify the file name length limit to meet the Linux naming convention. 
> In addition, the file name length is always bigger than 0, no need to 
> compare with 0 again.
> 
> Issue: #145
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Looks good, please send a test, thanks. You can copy portions of the
misc-tests/014-filesystem-label that does similar string length check
for the label.
