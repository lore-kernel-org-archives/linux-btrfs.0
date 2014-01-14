Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:43527 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaANO6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 09:58:47 -0500
Message-ID: <52D550A7.5060903@jrs-s.net>
Date: Tue, 14 Jan 2014 09:58:47 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>, jbacik@fb.com
Subject: Re: btrfs send: page allocation failure
References: <52D3E308.7060309@jrs-s.net> <20140113182312.GR6498@twin.jikos.cz> <52D4326B.6040009@jrs-s.net> <20140113185636.GU6498@suse.cz> <52D43898.5080801@jrs-s.net> <20140114131305.GV6498@suse.cz>
In-Reply-To: <20140114131305.GV6498@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FWIW, for those following along: took the system down for a reboot last 
night at 9PM EST, then tried the full send after the reboot - took 12 
hours or so to complete, but completed no issues, as have a few 
incremental sends since.

So, yeah, definitely looks related to kernel memory fragmentation AFAICT.

On 01/14/2014 08:13 AM, David Sterba wrote:
> On Mon, Jan 13, 2014 at 02:03:52PM -0500, Jim Salter wrote:
>> OK, thanks. If kernel memory fragmentation is a big factor, that would also
>> explain why it succeeds after a reboot but does not succeed after weeks of
>> uptime...
> Yes, that's it.

