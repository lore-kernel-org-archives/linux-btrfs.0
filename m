Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbaDKR7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 13:59:38 -0400
Date: Fri, 11 Apr 2014 19:59:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs-progs: update btrfs_file_extent_inline_len to
 match kernel version
Message-ID: <20140411175937.GI29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396977943-12427-1-git-send-email-fdmanana@gmail.com>
 <20140411174923.GH29256@twin.jikos.cz>
 <CAL3q7H4pf5DW0D+xHNqodARuqedkGTrnDa9S33mBy7QTcMoUtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4pf5DW0D+xHNqodARuqedkGTrnDa9S33mBy7QTcMoUtA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 11, 2014 at 06:51:58PM +0100, Filipe David Manana wrote:
> Thanks David.
> Can you add it please?
> I was using an older version of the integration branch.

Yes, fixed. The patch flux in the integration can cause minor issues and
I try to fix them myself if possible, sometimes with a note to the patch
authors.
