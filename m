Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:47460 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab3CJTLV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 15:11:21 -0400
Date: Sun, 10 Mar 2013 20:11:08 +0100
From: David Sterba <dave@jikos.cz>
To: Swasher <mr.swasher@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balance terminating
Message-ID: <20130310191108.GB29984@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <loom.20130309T124930-192@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20130309T124930-192@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 09, 2013 at 12:03:07PM +0000, Swasher wrote:
> After it, I'm start watch for progress via 'balance status', and I can see how 
> progress run. But only for 83% left. 
> 
> I'm wait few hours and try cancel it with 'balance cancel'.
> More than 12 hours had passed, but balance stalled in this state:
> 
> $ btrfs fi balance status /mnt/raid/  
> Balance on '/mnt/raid/' is running, cancel requested
> 386 out of about 2231 chunks balanced (387 considered),  83% left

What's the kernel version?

> Question: Can I'm safetly reboot server? Or should I do something else?

Yes it's safe. Please note that an interrupted balance will continue on
next mount unless 'skip_balance' is specified (and then balance cancel
will clear the state from the fs).

david
