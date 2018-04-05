Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbeDERRi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 13:17:38 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0D973AE01
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Apr 2018 17:17:37 +0000 (UTC)
Date: Thu, 5 Apr 2018 19:15:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop delayed_refs argument from
 btrfs_check_delayed_seq
Message-ID: <20180405171509.GO2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522846662-30109-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522846662-30109-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 04, 2018 at 03:57:42PM +0300, Nikolay Borisov wrote:
> It's used to print its pointer in a debug statement but doesn't really
> bring any useful information to the error message.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
