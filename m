Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbaH2OiH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 10:38:07 -0400
Date: Fri, 29 Aug 2014 16:38:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: readahead errors are not fatal
Message-ID: <20140829143804.GD31801@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1409161665-28234-1-git-send-email-dsterba@suse.cz>
 <20140827181603.GF12827@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140827181603.GF12827@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 27, 2014 at 11:16:03AM -0700, Zach Brown wrote:
> Seems like this is already leaking a refcount and only returns 0..  so
> maybe remove the bug_on something like this totally untested patch?

Looks much better than my patch, I'm taking it.

> There's another "#if 0"-ed out caller in extent-tree.c but that nonsense
> should just be removed.

Indeed, looking at the commit that added "#if 0", we're not interested
in the code anymore, feel free to kill it.

Thanks.
