Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab3IBO0i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 10:26:38 -0400
Date: Mon, 2 Sep 2013 16:26:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs-progs: Add Makefile infrastructure for subdirs
Message-ID: <20130902142635.GY23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
 <1370992519-21369-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370992519-21369-2-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 06:15:17PM -0500, Eric Sandeen wrote:
> Preparatory patch to move cmd & test files into their
> own subdirs.

I'm adding this to integration as it's just an infrastructure change,
but there are some bits missing before we can move more .c files into
their own subdirs. More under 'move files to tests/' patch.

david
