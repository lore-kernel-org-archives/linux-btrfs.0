Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934688AbcJ0R3I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 13:29:08 -0400
Date: Thu, 27 Oct 2016 19:29:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Prasanth K S R <kosigiprasanth@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com,
        Prasanth K S R <prasanth.ksr@dell.com>
Subject: Re: [PATCH V2] Btrfs-progs: subvol_uuid_search: Return error code on
 memory allocation failure
Message-ID: <20161027172903.GE12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1476679037-2485-1-git-send-email-kosigiprasanth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1476679037-2485-1-git-send-email-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 17, 2016 at 10:07:17AM +0530, Prasanth K S R wrote:
> From: Prasanth K S R <prasanth.ksr@dell.com>
> 
> This commit fixes coverity defect CID 1328695.

The patch does more than that. Please split it into two, one that
handles the memory allocations (the error message is not needed) and
anohter that switches to the IS_ERR/PTR_ERR return type. Thanks.
