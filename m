Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdCNMEB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 08:04:01 -0400
Date: Tue, 14 Mar 2017 13:03:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Jay Sharma <chandansbg@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, chandan.opensource@gmail.com
Subject: Re: [PATCH] btrfs: add support for extended file attributes
Message-ID: <20170314120322.GV14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1489482333-7409-1-git-send-email-chandansbg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1489482333-7409-1-git-send-email-chandansbg@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 02:35:33PM +0530, Chandan Jay Sharma wrote:
> This commit impliments FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR ioctls for BTRFS.

Can you please write more about what's the usecase and what's the
difference against normal XATTRs that btrfs already support?
Description, links etc. I can and will look it up but the changelog
should contain at least some basic information.
