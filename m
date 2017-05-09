Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757145AbdEIR3w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 13:29:52 -0400
Date: Tue, 9 May 2017 19:29:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com, fdmanana@gmail.com
Subject: Re: [PATCH v3] btrfs: relocation: Enhance kernel error output for
 relocation
Message-ID: <20170509172943.GI5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170215013905.17677-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170215013905.17677-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2017 at 09:39:05AM +0800, Qu Wenruo wrote:
> When balance(relocation) fails, btrfs-progs will report like:
> 
> ERROR: error during balancing '/mnt/scratch': Input/output error
> There may be more info in syslog - try dmesg | tail
> 
> However kernel can't provide may useful info in many cases to locate the
> problem.
> 
> This patch will add error messages in relocation to help user and
> developer to locate the problem.

I think it's too verbose for a user, and not really helpful what to do
after such error message appears in the log. The errors translate name
of the last function that failed, so the user would need to be familiar
with the inner workings of the balance to make sense of it.

The meessages may make sense to a developer, but then it's not necessary
to print them as btrfs_err, but btrfs_debug.
