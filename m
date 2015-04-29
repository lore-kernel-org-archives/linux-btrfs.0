Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbbD2Pis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 11:38:48 -0400
Date: Wed, 29 Apr 2015 17:38:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] btrfs-progs: separate the overwrite check.
Message-ID: <20150429153846.GA4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <55392221.6090502@gmail.com>
 <55392315.8040306@gmail.com>
 <20150424152428.GS4996@twin.jikos.cz>
 <CAPL5yKetu1whj4ON+NQPJk6Z06Jnqz3MQGf6Dx=3nKqAB8Vw-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPL5yKetu1whj4ON+NQPJk6Z06Jnqz3MQGf6Dx=3nKqAB8Vw-g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 25, 2015 at 02:19:47PM -0400, Dan Merillat wrote:
> It's a good question.  If path_name is absolute, the file descriptor
> is ignored.

AFAICS the paths are just appended to what the user specifies on the
commandline, so it's not necessarily an absolute path. However, it still
works with -1 as expected. I'll merge the patch as-is (scheduled for
4.0.1) so there's time to test it.
