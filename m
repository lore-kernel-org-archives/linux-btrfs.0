Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60806 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752280AbdI2QXg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 12:23:36 -0400
Date: Fri, 29 Sep 2017 18:22:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 0/6] Btrfs: populate heuristic with code
Message-ID: <20170929162200.GP31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 05:33:35PM +0300, Timofey Titovets wrote:
> Compile tested, hand tested on live system
> 
> Change v7 -> v8
>   - All code moved to compression.c (again)
>   - Heuristic workspaces inmplemented another way
>     i.e. only share logic with compression workspaces
>   - Some style fixes suggested by Devid
>   - Move sampling function from heuristic code
>     (I'm afraid of big functions)
>   - Much more comments and explanations

Thanks for the update, I went through the patches and they looked good
enough to be put into for-next. I may have more comments about a few
things, but nothing serious that would hinder testing.
