Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994Ab3JOQtp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 12:49:45 -0400
Date: Tue, 15 Oct 2013 18:49:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: check return value of realpath(3)
Message-ID: <20131015164941.GL5787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381592872-24751-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381592872-24751-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 12, 2013 at 11:47:52PM +0800, Eryu Guan wrote:
> I hit a segfault when deleting a subvolume with very long name(>4096),

How do you get a valid pathname longer than PATH_MAX which is 4096 ?

> Fix it by checking return value of realpath(3), also fix the one in
> find_mount_root().

The error handling itself is ok.

david
