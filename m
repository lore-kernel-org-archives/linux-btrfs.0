Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab3CRMkk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 08:40:40 -0400
Date: Mon, 18 Mar 2013 13:40:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add skinny metadata support to progs V2
Message-ID: <20130318124038.GL7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363373549-15423-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363373549-15423-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 15, 2013 at 02:52:29PM -0400, Josef Bacik wrote:
> This fixes up the progs to properly deal with skinny metadata.  This adds the -x
> option to mkfs and btrfstune for enabling the skinny metadata option.

We'll cover the filesystem features with one option (-O), I've sent a
patch for that but need to rewrite it to be more flexible. Extending
btrfstune to tweak the features is only a bandaid (better than nothing).

david
