Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932849AbdHVOdE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:33:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4513AE1F
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 14:33:02 +0000 (UTC)
Date: Tue, 22 Aug 2017 16:31:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Use named constants for common sizes
Message-ID: <20170822143139.GZ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1501143420-28062-1-git-send-email-nborisov@suse.com>
 <1501143420-28062-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501143420-28062-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 11:17:00AM +0300, Nikolay Borisov wrote:
> There multiple places where we use well-known sizes - 1,8,16,32 megabytes. We
> also have them defined as constants in the sizes.h header. So let's use them.
> No functional changes.

Both applied, thanks.
