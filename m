Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751077AbdFEPhi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Jun 2017 11:37:38 -0400
Date: Mon, 5 Jun 2017 17:36:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Guoqing Jiang <gqjiang@suse.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: simplify code with bio_io_error
Message-ID: <20170605153635.GV12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170602080850.5410-1-gqjiang@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170602080850.5410-1-gqjiang@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 02, 2017 at 04:08:50PM +0800, Guoqing Jiang wrote:
> bio_io_error was introduced in the commit 4246a0b
> ("block: add a bi_error field to struct bio"), so
> use it to simplify code.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
