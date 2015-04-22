Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbbDVRBK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 13:01:10 -0400
Date: Wed, 22 Apr 2015 19:01:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 0/1] btrfs-progs: optionally restore metadata
Message-ID: <20150422170108.GH4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5535E4B8.9000909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5535E4B8.9000909@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 21, 2015 at 01:48:40AM -0400, Dan Merillat wrote:
> Symlinks and hardlinks are beyond the scope of these changes, I'll look
> into them if this looks good to everyone.

That would be appreciated. I'll send you a POC code to dump the
symlinks, it's missing the actual file creation and commandline
interface etc.
