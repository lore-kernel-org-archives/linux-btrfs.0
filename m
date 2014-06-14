Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51848 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbaFNODV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Jun 2014 10:03:21 -0400
Date: Sat, 14 Jun 2014 15:00:50 +0200
From: David Sterba <dave@jikos.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org,
        dave@jikos.cz
Subject: Re: [PATCH 2/2] Remove a leading '+'.
Message-ID: <20140614130050.GT23096@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1402695276-28104-1-git-send-email-abuchbinder@google.com>
 <1402695276-28104-2-git-send-email-abuchbinder@google.com>
 <539B7131.9070005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539B7131.9070005@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 13, 2014 at 04:46:25PM -0500, Eric Sandeen wrote:
> > -+	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
> > +	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
> Whoa, git blame blames me, but that's not the patch I sent.  ;)

My mistak while merging two conflicting show-super patches, sorry.
