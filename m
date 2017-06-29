Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49567 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751618AbdF2UZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 16:25:07 -0400
Subject: Re: [PATCH v2 1/2] btrfs: account for pinned bytes in
 should_alloc_chunk
To: Jeff Mahoney <jeffm@suse.com>, Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
References: <20170622135148.16730-1-jeffm@suse.com>
 <20170629192141.GA20229@vader.DHCP.thefacebook.com>
 <b431385d-049f-5972-b5f2-367b7d3e4c7c@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <348f6461-dc38-7a70-4b5a-a9b20f3695b5@suse.com>
Date: Thu, 29 Jun 2017 23:25:04 +0300
MIME-Version: 1.0
In-Reply-To: <b431385d-049f-5972-b5f2-367b7d3e4c7c@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.06.2017 22:49, Jeff Mahoney wrote:
> Our test environment is just installing the OS.  That means lots of
> creates, writes, and then renames, so there's a fair amount of metadata
> churn that results in elevated pinned_bytes.  Rsync can cause the same
> workload pretty easily too.  Nikolay was going to look into coming up
> with a configuration for fsstress that would emulate it.

I did experiment with fsstress -f rename=65 -f write=35 but this thing
just exhausted the filesystem completely, no premature ENOSPC. I also
tried doing just rename on a fs which has around 1gb free space and
again the usage was steadily incrased but no enospc was observed ;\
