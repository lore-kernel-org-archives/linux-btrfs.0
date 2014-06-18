Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaFROno (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 10:43:44 -0400
Date: Wed, 18 Jun 2014 16:43:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix undefined behavior in radix-tree.c.
Message-ID: <20140618144342.GV1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1402694330-21211-1-git-send-email-abuchbinder@google.com>
 <53A12FAE.7060307@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A12FAE.7060307@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 03:20:30PM +0900, Satoru Takeuchi wrote:
> Hi Adam,
> 
> (2014/06/14 6:18), Adam Buchbinder wrote:
> > When running with UndefinedBehaviorSanitizer, the tests produce the following
> > error:
> > 
> >    radix-tree.c:836:30: runtime error: shift exponent 18446744073709551613
> >    is too large for 64-bit type 'unsigned long'
> > 
> > (That's a negative shift exponent represented as an unsigned long.)
> > 
> > Even though the value is discarded in those cases, it's still undefined
> > behavior; see the C99 standard, section 6.5.7, paragraph three: "If the
> > value of the right operand is negative [...] the behavior is undefined."
> > 
> > Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> 
> It looks good to me.
> 
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thank you both.

The file is taken from kernel/lib/radix-tree.c and has diverged a bit so
it could be missing more bugfixes.
