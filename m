Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbbJGJrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 05:47:12 -0400
Date: Wed, 7 Oct 2015 11:46:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com,
        david@fromorbit.com
Subject: Re: [RFC][PATCH] btrfs: add ioctl to monitor subvolume dropping
Message-ID: <20151007094606.GJ7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20151001213047.GB1044@wotan.suse.de>
 <20151006082552.GA7734@twin.jikos.cz>
 <20151006170926.GC1044@wotan.suse.de>
 <20151006194202.GD1044@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151006194202.GD1044@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 06, 2015 at 12:42:02PM -0700, Mark Fasheh wrote:
> Hmm this isn't working for me, am I doing anything wrong? 

You are not, there's a bug in the 'subvol sync' command sorry. I found
it just yesterday.

https://patchwork.kernel.org/patch/7334131/

I'll do a progs release soon with this fix included.
