Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbE1Mhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 May 2015 08:37:52 -0400
Date: Thu, 28 May 2015 14:37:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: specify mountpoint for recieve
Message-ID: <20150528123750.GR23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432749089-14663-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432749089-14663-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 27, 2015 at 01:51:29PM -0400, Josef Bacik wrote:
> In a chroot environment we may not have /proc mounted, which makes btrfs receive
> freak out since it wants to know the base directory where are are mounted for
> things like clone and such

Does this https://patchwork.kernel.org/patch/6456671/ fix the problem
with clones?
