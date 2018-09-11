Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726800AbeIKVjA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 17:39:00 -0400
Date: Tue, 11 Sep 2018 18:38:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/6] btrfs-progs: Variant fixes for fuzz-tests
Message-ID: <20180911163851.GG2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180803055022.9816-1-wqu@suse.com>
 <d844475b-f06a-4149-4259-999b08e3dd09@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d844475b-f06a-4149-4259-999b08e3dd09@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 29, 2018 at 01:27:39PM +0800, Qu Wenruo wrote:
> Gentle ping.
> 
> These fixes are pretty small, I'd like to see them merged before I need
> to rebase them again and again.

I've merged them now, thanks. I had to edit all changelogs and remove
the ----- lines, shortened the paths in the test logs and fixed typos.
Please have a look at the committed patches and compare to what you
sent.
