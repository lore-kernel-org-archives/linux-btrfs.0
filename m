Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:39224 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2GQM6I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 08:58:08 -0400
Date: Tue, 17 Jul 2012 14:58:05 +0200
From: David Sterba <dave@jikos.cz>
To: Pierre Carrier <pierre@spotify.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] utils.c: offer to limit divisions in pretty_sizes
Message-ID: <20120717125805.GE11226@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1341853347-11788-3-git-send-email-pierre@spotify.com>
 <1341855021-14551-1-git-send-email-pierre@spotify.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341855021-14551-1-git-send-email-pierre@spotify.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2012 at 05:30:21PM +0000, Pierre Carrier wrote:
> Dirty hack to allow inspection of sizes in lower units.

A commandline option would suit better IMHO. If this is a one-shot task
to find the sizes expressed with a different multiplier, then I don't
understhand the env variable approach. If it's meant to express all
size-related numbers with a given multiplier, than it could make sense,
but it has to be well documented and possibly a better variable name
picked.

Hugo referenced one of his patches,
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06518.html
that adds -h or -H (1024-based and SI-based), but that does not fix the
problem that you want to se a specific size. So, I'm suggesting a
generic option

--units=PFX

where PFX can be arbitrary from KB, KiB and the rest of the list. Plus a
way to include the human-readable forms, both 1024- and SI-based.


david
