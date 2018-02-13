Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965144AbeBMRBG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 12:01:06 -0500
Date: Tue, 13 Feb 2018 17:58:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix bare unsigned declarations
Message-ID: <20180213165849.GZ3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213095048.9550-1-anand.jain@oracle.com>
 <20180213095048.9550-7-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180213095048.9550-7-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 05:50:48PM +0800, Anand Jain wrote:
> Kernel style prefers "unsigned int <foo>" over "unsigned <foo>"
> and "signed int <foo>" over "signed <foo>".

The changelog does not match the changes, you're switching to u32. I
agree u32 looks more suitable and consistent with the other changes.
Please update the changelog and fixup the temporary variable in
btrfs_remount. Thanks.
