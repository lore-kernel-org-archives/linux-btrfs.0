Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35242 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2I3X2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 19:28:42 -0400
Date: Mon, 1 Oct 2012 01:28:35 +0200
From: David Sterba <dave@jikos.cz>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH 2/2] btrfs: move inline function code to header file
Message-ID: <20120930232835.GO14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348906067-9348-1-git-send-email-robin.k.dong@gmail.com>
 <1348906067-9348-2-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348906067-9348-2-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 29, 2012 at 04:07:47PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> When building btrfs from kernel code, it will report:
> 
> 	fs/btrfs/extent_io.h:281: warning: 'extent_buffer_page' declared inline after being called
> 	fs/btrfs/extent_io.h:281: warning: previous declaration of 'extent_buffer_page' was here
> 	fs/btrfs/extent_io.h:280: warning: 'num_extent_pages' declared inline after being called
> 	fs/btrfs/extent_io.h:280: warning: previous declaration of 'num_extent_pages' was here
> 
> because of the wrong declaration of inline functions.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Yep, makes sense, thanks.

david
