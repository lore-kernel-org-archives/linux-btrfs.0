Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbbFZOeu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 10:34:50 -0400
Date: Fri, 26 Jun 2015 16:34:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: replace struct cmd_group->hidden with
 flags
Message-ID: <20150626143448.GX726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1435161735.git.osandov@fb.com>
 <2368516acde293032f9dae5117136fbf138e33c3.1435161735.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2368516acde293032f9dae5117136fbf138e33c3.1435161735.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 09:09:16AM -0700, Omar Sandoval wrote:
> We're also going to want to support aliases, so rather than adding
> another member, replace "hidden" with a "flags" member.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Fixed compilation breakage and applied, thanks.
