Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab3HFPbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 11:31:16 -0400
Date: Tue, 6 Aug 2013 17:31:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PROGS PATCH] Import btrfs-extent-same
Message-ID: <20130806153112.GL5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51CB6D5B.70302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51CB6D5B.70302@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 27, 2013 at 12:38:19AM +0200, Gabriel de Perthuis wrote:
> Originally from
> https://github.com/markfasheh/duperemove/blob/master/btrfs-extent-same.c

Can you (or Mark) please turn it into a subcommand of dedup? The idea is
to merge both in-bound and out-bound dedup into one command, eg.

 btrfs dedup files dir/*

Liu Bo's dedup patch is in today's integration snapshot
http://repo.or.cz/w/btrfs-progs-unstable/devel.git/shortlog/refs/heads/integration-20130806-2

you can use it as a base.

thanks,
david
