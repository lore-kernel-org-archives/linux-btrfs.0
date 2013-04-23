Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646Ab3DWQJd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 12:09:33 -0400
Date: Tue, 23 Apr 2013 18:09:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] btrfs-progs: standardize utility filenames and add
 default rules to Makefile
Message-ID: <20130423160930.GV16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <517463E4.7040400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <517463E4.7040400@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 21, 2013 at 05:10:44PM -0500, Eric Sandeen wrote:
> 2 patches here.

I see only

[PATCH 2/2] btrfs-progs: Add default rules to Makefile

in my mbox that's threaded under the 0/2 cover mail.

> I think this is a net win, with a bit less Makefile code
> duplication, but if people don't like it, no big deal.  I was hoping
> to clean up & re-organize the userspace build a little, and this
> seems like a decent first step along the way.

Looks ok to me, the rule duplication was obvious and asking for a
cleanup.

david
