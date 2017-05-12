Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932297AbdELOs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 10:48:28 -0400
Date: Fri, 12 May 2017 16:48:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH v2 0/2] btrfs: allow mechanism to override quota
Message-ID: <20170512144818.GI27439@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170511211658.GA8401@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170511211658.GA8401@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 11, 2017 at 09:17:01PM +0000, Sargun Dhillon wrote:
> This patchset makes it so that on a per-filesystem basis one can disable
> quota enforcement for users with cap_sys_resource. This patchset can
> likely later be extended to per-qgroup, or a per-volume basis. I'm
> thinking of extending the sysfs interface to list the qgroups and
> this same interface for the qgroups themselves.
> 
> Changes since v1:
>   -Rather than a separate member of btrfs_fs_info, use the existing
>    flags field

Looks good to me, thanks.
