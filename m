Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab3IJAIB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 20:08:01 -0400
Date: Tue, 10 Sep 2013 02:07:59 +0200
From: David Sterba <dsterba@suse.cz>
To: "Chris West (Faux)" <git@goeswhere.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: ctree: widen int->long due to PTR_ERR()
Message-ID: <20130910000759.GX32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130909220651.GA10244@goeswhere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130909220651.GA10244@goeswhere.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure this change is necessary. The code is inherited from
kernel, I doubt that this would be wrong && unnoticed. PTR_ERR should
be always used after IS_ERR, this does all the typecasts and checks,
the final value is in the range of -MAX_ERRNO..0. MAX_ERRNO is 4095,
even if long is wider than int, there is no loss.

Did you turn on some extra compiler warnings?

david
