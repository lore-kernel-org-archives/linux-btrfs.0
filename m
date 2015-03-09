Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbbCILtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 07:49:16 -0400
Date: Mon, 9 Mar 2015 12:49:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] btrfs: fix size_t format string
Message-ID: <20150309114914.GD5841@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2448187.keuqSF9F23@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2448187.keuqSF9F23@wuerfel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 09, 2015 at 12:39:36PM +0100, Arnd Bergmann wrote:
> This warning has been rather annoying because it shows up in every
> 'allmodconfig' build. I assume others have reported it before, but
> please apply some fix for it, ideally before 4.0.

Sorry about that, we're aware of the warning and Chris will push the
patch to the next rc.
