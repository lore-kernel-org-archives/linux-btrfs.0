Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752078AbdFMNqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 09:46:10 -0400
Date: Tue, 13 Jun 2017 15:45:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v6] Btrfs: compression must free at least one sector size
Message-ID: <20170613134504.GW25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170606114115.21602-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606114115.21602-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 02:41:15PM +0300, Timofey Titovets wrote:
> Btrfs already skip store of data where compression didn't
> free at least one byte. Let's make logic better and make check
> that compression free at least one sector size
> because in another case it useless to store this data compressed
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've updated the changelog a bit.
