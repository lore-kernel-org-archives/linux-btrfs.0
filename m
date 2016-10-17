Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46103 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934704AbcJQOGN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 10:06:13 -0400
Date: Mon, 17 Oct 2016 16:06:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Junjie Mao <junjie.mao@enight.me>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: assign error values to the correct bio structs
Message-ID: <20161017140610.GK11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1476667225-7833-1-git-send-email-junjie.mao@enight.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1476667225-7833-1-git-send-email-junjie.mao@enight.me>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 17, 2016 at 09:20:25AM +0800, Junjie Mao wrote:
> Fixes: 4246a0b63bd8 ("block: add a bi_error field to struct bio")
> 
> Signed-off-by: Junjie Mao <junjie.mao@enight.me>

Ack, but please resend it with CC: stable@vger.kernel.org # 4.3+
