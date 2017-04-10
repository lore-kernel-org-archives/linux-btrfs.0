Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754701AbdDJQsT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 12:48:19 -0400
Date: Mon, 10 Apr 2017 18:47:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix missing newline in man 5 btrfs
Message-ID: <20170410164749.GD4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170408223747.28157-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170408223747.28157-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 09, 2017 at 12:37:47AM +0200, Hans van Kranenburg wrote:
> The text compress_lzo:: would show up directly after 'bigger than the
> page size' on the same line.

Applied, thanks.
