Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdJPOjN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:39:13 -0400
Date: Mon, 16 Oct 2017 16:37:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: Use bd_dev to generate index when
 dev_state_hashtable add items.
Message-ID: <20171016143726.GQ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1507711467-50249-1-git-send-email-gujx@cn.fujitsu.com>
 <6bf1ac45-4c29-e60a-ce55-041948c6a940@suse.com>
 <780868f7-ef78-8bde-ea41-69e75193375f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <780868f7-ef78-8bde-ea41-69e75193375f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 12:22:35PM +0300, Nikolay Borisov wrote:

Patch added to queue, thanks.

> On a slightly different note the check-integrity.c file could really
> make use of the hashtable.h API but that's a bit more work. In any case
> I think what could be done to reduce the likelihood of such errors is to
> introduce functions/macros which calculate the correct key when it's
> necessary rather than open-coding it.

The integrity checker is a debugging feature and sepate from the rest.
Though the code could use a lot of cleanups, it's not something I'm
concerned about, as long as it works.
