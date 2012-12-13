Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:43863 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab2LMVef (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 16:34:35 -0500
Date: Thu, 13 Dec 2012 22:34:30 +0100
From: David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@fusionio.com>, Pascal Junod <pascal@junod.info>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [btrfs] is vulnerable to a hash-DoS attack
Message-ID: <20121213213430.GB22426@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50C9D085.3020305@junod.info>
 <20121213205208.GA27308@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121213205208.GA27308@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 13, 2012 at 03:52:08PM -0500, Chris Mason wrote:
> Thanks for taking the time to write this up.  As far as I can tell, the
> looping was actually fixed in an older kernel and I just misread our
> version string in your original email.

Yeah, the blogpost says 3.3.7. I did a quick test with 3.7 and was not
able to reproduce it.

david
