Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbbENNkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 09:40:36 -0400
Date: Thu, 14 May 2015 15:40:35 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.0.1-rc1
Message-ID: <20150514134035.GX23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150513171753.GV23255@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150513171753.GV23255@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 07:17:53PM +0200, David Sterba wrote:
> Changes:
> * restore can restore symlinks

Due to a mistake on my side, I need to rebase the development branch.
Two restore-symlink git commits are wrongly credited to me instead of
Dan Merillat. This will be fixed in the next rc. I'm sorry.
