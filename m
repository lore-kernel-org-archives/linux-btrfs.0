Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44213 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750748AbdAXQmc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 11:42:32 -0500
Date: Tue, 24 Jan 2017 17:42:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 1/2] btrfs-progs: qgroup: add sync option to 'qgroup
 show'
Message-ID: <20170124164213.GX11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201612150429.AA00024@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201612150429.AA00024@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 15, 2016 at 01:29:28PM +0900, Tsutomu Itoh wrote:
> The 'qgroup show' command does not synchronize filesystem.
> Therefore, 'qgroup show' may not display the correct value unless
> synchronized with 'filesystem sync' command etc.
> 
> So add the '--sync' option so that we can choose whether or not
> to synchronize when executing the command.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

1 and 2 applied, thanks.
