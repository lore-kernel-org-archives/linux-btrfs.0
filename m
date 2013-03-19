Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab3CSJG6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 05:06:58 -0400
Date: Tue, 19 Mar 2013 10:06:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
Message-ID: <20130319090653.GQ7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <514759B5.5000507@lolwut.org>
 <20130318191815.15073.49770@localhost.localdomain>
 <A0DACC7D-01E5-4D36-9526-E871F4E045B6@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <A0DACC7D-01E5-4D36-9526-E871F4E045B6@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 18, 2013 at 09:18:28PM -0600, Chris Murphy wrote:
> I'm not finding a reference to "secure erase trim". In any case I
> wouldn't expect it to differ from trim.

There's a 'secure discard' trim command in linux,

http://lkml.indiana.edu/hypermail/linux/kernel/1007.1/02355.html

Used inside block layer
http://lxr.free-electrons.com/source/block/blk-core.c#L1738
(assumes the underlying device advertises the secure discard capability)

david
