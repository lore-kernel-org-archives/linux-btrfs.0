Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbaFWNuA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 09:50:00 -0400
Date: Mon, 23 Jun 2014 15:49:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: restore: check lzo compress length
Message-ID: <20140623134958.GE1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403110279-28688-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1403110279-28688-1-git-send-email-vincent.stehle@laposte.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 06:51:19PM +0200, Vincent Stehlé wrote:
> This patch actually allowed me to finish a btrfs restore of a damaged
> filesystem, which was repeateadly crashing otherwise. This was with v3.12, but
> I think it still makes sense.

It does, thanks.
