Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751978AbdC0RyS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:54:18 -0400
Date: Mon, 27 Mar 2017 19:37:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: kerncompat: Fix re-definition of
 __bitwise
Message-ID: <20170327173735.GR4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 16, 2017 at 11:18:30AM +0800, Qu Wenruo wrote:
> In latest linux api headers, __bitwise is already defined in
> /usr/include/linux/types.h.
> 
> So kerncompat.h will re-define __bitwise, and cause gcc warning.
> 
> Fix it by checking if __bitwise is already define.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
