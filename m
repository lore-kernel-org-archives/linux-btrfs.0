Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753943AbdKIQ5R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 11:57:17 -0500
Date: Thu, 9 Nov 2017 17:55:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/3] add_qgroup/update_qgroup/__qgroup_search cleanup
Message-ID: <20171109165523.GP27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031091345.9325-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 05:13:42PM +0800, Lu Fengqi wrote:
> Patch 1 just remove the redundant function add_qgroup.
> Patch 2 separate QGROUP_INFO/QGROUP_LIMIT/QGROUP_RELATION process from
> the update_qgroup.
> Patch 3 mainly the coding style adjustment.

This per-patch description is fine, and not always necessary if the
patch subjects and changelogs are sufficient. The cover letter could be
some overview what are the patches addressing.

> 
> Lu Fengqi (3):
>   btrfs-progs: qgroup: cleanup the redundant function add_qgroup
>   btrfs-progs: qgroup: split update_qgroup to reduce arguments

1 and 2 applied, the cleanups look very good, thanks.

>   btrfs-progs: qgroup: cleanup __qgroup_search, no functional change

Not applied, please see the comments.
