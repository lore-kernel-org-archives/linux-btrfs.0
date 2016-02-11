Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbcBKRxN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 12:53:13 -0500
Date: Thu, 11 Feb 2016 18:53:10 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: linux-btrfs@vger.kernel.org, "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Subject: Re: [PATCH][btrfs-progs] Include file verification with convert-tests
Message-ID: <20160211175310.GF4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1453738113-19583-1-git-send-email-Lakshmipathi.G@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453738113-19583-1-git-send-email-Lakshmipathi.G@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 09:38:33PM +0530, Lakshmipathi.G wrote:
> From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
> 
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>

Applied, thanks.

The external checksum verification is a good thing to do. We'll have to
add some ways to populate the filesystems, by external scripts/tools or
some local to this testsuite.
