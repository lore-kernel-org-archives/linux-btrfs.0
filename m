Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751200AbdGMOao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 10:30:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5E0DAC41
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 14:30:42 +0000 (UTC)
Subject: Re: [PATCH] btrfs: drop newlines from strings when using btrfs_*
 helpers
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20170713134344.6612-1-dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <49265f37-1d9f-054c-6f78-458c172897c7@suse.com>
Date: Thu, 13 Jul 2017 17:30:41 +0300
MIME-Version: 1.0
In-Reply-To: <20170713134344.6612-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.07.2017 16:43, David Sterba wrote:
> The helpers append "\n" so we can keep the actual strings shorter. The
> extra newline will print an empty line.  Some messages have been
> slightly modified to be more consistent with the rest (lowercase first
> letter).
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com
