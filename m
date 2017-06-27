Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52749 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751928AbdF0PuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 11:50:03 -0400
Date: Tue, 27 Jun 2017 17:48:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: linux-btrfs@vger.kernel.org, lufq.fnst@cn.fujitsu.com
Subject: Re: [PATCH 07/13] btrfs: remove ref_tree implementation from
 backref.c
Message-ID: <20170627154847.GY2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-8-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170620160653.19907-8-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 10:06:47AM -0600, Edmund Nadolski wrote:
> The BACKREF_FOUND_SHARED checking will be addressed in an upcoming
> patch.

So this reverts the commit afce772e87c36c7f07f230a76d525025aaf09e41
"btrfs: fix check_shared for fiemap ioctl", this should be mentioned in
the changelog. Also the code is not that old, 09/2016 so I'd expect some
reasoning why reverting is the best option here, and also CC the
original author.

The ref_root is supposed to fix some problem, I get that you've chosen a
different approach to address but this would be good to have mentioned
in the changelog.

Both approaches do not seem to be compatible and could coexist so
removing the code is fine, although this would introduce the original
problem for a few commits. I don't think this is a problem.
