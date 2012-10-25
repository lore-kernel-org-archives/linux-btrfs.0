Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45696 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab2JYP1a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 11:27:30 -0400
Date: Thu, 25 Oct 2012 17:27:22 +0200
From: David Sterba <dave@jikos.cz>
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: "frantz.hacquard" <frantz.hacquard@ensi-bourges.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: help with btrfs send
Message-ID: <20121025152722.GH10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <d867c8a573d19560c7b7f3aba7394b10@ensi-bourges.fr>
 <20121024172332.GC8624@campbell-lange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121024172332.GC8624@campbell-lange.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 24, 2012 at 06:23:32PM +0100, Rory Campbell-Lange wrote:
> The output of 'btrfs send' is in binary format. You can read more about
> what is contained in the data stream in Jonathan Corbet's posting at LWN
> here http://lwn.net/Articles/506244/
> 
> You'd normally do send/receive something like this:
> 
>     btrfs send /backup/start | btrfs receive /destination

We should not try to send the binary data into a terminal anyway, I'm
sending a patch to fix that.

thanks,
david
