Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab3DVNhc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:37:32 -0400
Date: Mon, 22 Apr 2013 15:37:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: data DUP
Message-ID: <20130422133729.GM16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <kkut3u$lp1$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <kkut3u$lp1$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 20, 2013 at 01:17:06PM -0700, Roger Binns wrote:
> Is there any particular reason why I can't use DUP for data?

IIRC separate DUP for metadata and data is not possible due to some
technical reason (I don't remember nor can find the mail where this was
mentioned).

DUP data is possible only in the --mixed mode so this

 mkfs.btrfs --mixed -d dup -m dup /dev/ice

works.

david
