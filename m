Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506AbaELOPj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 10:15:39 -0400
Date: Mon, 12 May 2014 16:15:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: superfluous " else if ()"
Message-ID: <20140512141538.GB6917@suse.cz>
Reply-To: dsterba@suse.cz
References: <535C017C.7060509@gmx.de>
 <20140509164902.GA6039@twin.jikos.cz>
 <536D0C96.4020705@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <536D0C96.4020705@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 07:12:54PM +0200, Toralf Förster wrote:
> But what came into my mind, wouldn't the following avoid such question in future ? :

Yes and though it's a tiny change, I don't mind a patch for that.

>          } else {
> 		/* ret < 0 */

The comment is IMHO unnecessary.
