Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55543 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750770AbdEBROj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 13:14:39 -0400
Date: Tue, 2 May 2017 19:14:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Praveen K Pandey <praveen@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] Btrfs-progs: run_next_block: Return error code when
 extent buffer read fails
Message-ID: <20170502171432.GU23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1493033237-12979-1-git-send-email-praveen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493033237-12979-1-git-send-email-praveen@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 24, 2017 at 04:57:17PM +0530, Praveen K Pandey wrote:
> run_next_block() ignores the return value of read_tree_block() and
> always returns success status. This might cause deal_root_from_list()
> to loop infinitely when reading metadata block fails. This bug fixes
> the issue by extracting and returning the error code from the return
> value of read_tree_block().
> 
> Bug ID : https://bugzilla.kernel.org/show_bug.cgi?id=155551
> 
> Signed-off-by: Praveen K Pandey <praveen@linux.vnet.ibm.com>

Applied, thanks. As noted in the bug, there are many more to fix.
