Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51553 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933308AbeFUNdv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 09:33:51 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5C91CAC21
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 13:33:50 +0000 (UTC)
Date: Thu, 21 Jun 2018 15:31:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/34] fs_info cleanup of extent-tree.c
Message-ID: <20180621133100.GO24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 03:48:42PM +0300, Nikolay Borisov wrote:
> Overall this series is a win both in code density as well as stack usage and 
> brings us closer to completely eliminating the chaotic spread ot fs_info in 
> the code base. 

The fs_info provided by the transaction handle is a recent addition,
previously everything had to pass fs_info around so they were
duplicated, until now.

The gains in saved stack space and code size are small but every bit
counts, thanks. Patches added to misc-next.
