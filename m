Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60585 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab2IXNSp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 09:18:45 -0400
Date: Mon, 24 Sep 2012 15:15:31 +0200
From: David Sterba <dave@jikos.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: linux-btrfs@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 4/4] Btrfs: tivial cleanup: add space between = and the
 rest code
Message-ID: <20120924131531.GE14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <505FADA5.3070500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505FADA5.3070500@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 08:47:33AM +0800, Wang Sheng-Hui wrote:
> trivial code cleanup.

> -			ret =btrfs_drop_snapshot(root, NULL, 1, 0);
> +			ret = btrfs_drop_snapshot(root, NULL, 1, 0);

Sorry but this is too trivial.

Unless it really bugs you when you're going through code, I don't think
that cleanups at this level are necessary. Reading through commit
history of some code via 'git blame' and seeing such cleanups is not
welcome.

I have a patchet in testing that updates a few things around snapshot
cleaning and this line will get fixed, so it'll not stay forever.

david
