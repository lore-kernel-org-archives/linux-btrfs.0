Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaANNNH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 08:13:07 -0500
Date: Tue, 14 Jan 2014 14:13:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Jim Salter <jim@jrs-s.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jbacik@fb.com
Subject: Re: btrfs send: page allocation failure
Message-ID: <20140114131305.GV6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <52D3E308.7060309@jrs-s.net>
 <20140113182312.GR6498@twin.jikos.cz>
 <52D4326B.6040009@jrs-s.net>
 <20140113185636.GU6498@suse.cz>
 <52D43898.5080801@jrs-s.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D43898.5080801@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 13, 2014 at 02:03:52PM -0500, Jim Salter wrote:
> OK, thanks. If kernel memory fragmentation is a big factor, that would also
> explain why it succeeds after a reboot but does not succeed after weeks of
> uptime...

Yes, that's it.
