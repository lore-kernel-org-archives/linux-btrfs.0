Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbcBVL5u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 06:57:50 -0500
Date: Mon, 22 Feb 2016 12:57:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Simon Quigley <tsimonq2@ubuntu.com>
Cc: clm@fb.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: backref: Fixed checkpatch warning of over 80
 characters
Message-ID: <20160222115741.GC4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 20, 2016 at 12:17:38PM -0600, Simon Quigley wrote:
> checkpatch.pl reported a warning of over 80 characters on line 1833

Please read the answers from Filipe or me

http://article.gmane.org/gmane.comp.file-systems.btrfs/53421
http://article.gmane.org/gmane.comp.file-systems.btrfs/53422

in short, whitespace-only changes do not help too much.
