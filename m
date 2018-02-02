Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35360 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753052AbeBBSJo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 13:09:44 -0500
Date: Fri, 2 Feb 2018 19:07:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, quwenruo.btrfs@gmx.com
Subject: Re: [RFC PATCH v2 2/4] btrfs-progs: Add EXEC represent path of
 executable file
Message-ID: <20180202180730.GA18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
 <1517560445-5712-3-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1517560445-5712-3-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 02, 2018 at 04:34:03PM +0800, Gu Jinxiang wrote:
> Use EXEC instead of TOP to represent the path of excutable file.
> EXEC is set to TOP by default, but when there is no excutable file
> in TOP, use the path where btrfs is install as EXEC.

What if we just allow to change TOP (ie. do not overwrite it in the test
driver scripts)? The logic will be the same as with EXEC, but we won't
have to rewrite essentailly all paths in the testsuite.
