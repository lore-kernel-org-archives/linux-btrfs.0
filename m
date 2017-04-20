Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53861 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S943270AbdDTLwl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 07:52:41 -0400
Date: Thu, 20 Apr 2017 13:52:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 1/2] btrfs-progs: dump-super: check array_size in
 print_sys_chunk_array
Message-ID: <20170420115236.GJ22319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170420080757.1895-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170420080757.1895-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 20, 2017 at 04:07:56PM +0800, Lu Fengqi wrote:
> Without validation of array_size, the dump-super may lead to a bad
> memory access.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

1-2 applied, thanks.
