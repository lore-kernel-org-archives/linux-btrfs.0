Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbbFZNdZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 09:33:25 -0400
Date: Fri, 26 Jun 2015 15:33:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Omar Sandoval <osandov@fb.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/2] btrfs device remove alias
Message-ID: <20150626133323.GS726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1435161735.git.osandov@fb.com>
 <558CA6A0.20401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <558CA6A0.20401@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 26, 2015 at 09:10:56AM +0800, Anand Jain wrote:
> while on this. its also good idea to create alias for
> 
>    btrfs replace start -> btrfs device replace.

This was asked for back then, and briefly discussed on irc (11/2012).
The preference was not to do too much typing, although the command
hierarchy would become less structured and can cause some trouble when
looking for docs.

I'm slightly worried about adding more aliases as it can cause confusion
when writing documentaiton and recommending how to do things.  But I
understand the motivations to make the interface more consistent or
convenient to use.

In this case it's moving replace to the expected place. I'm not against
it but more feedback would help.
