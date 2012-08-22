Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:40969 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932615Ab2HVOlC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 10:41:02 -0400
Date: Wed, 22 Aug 2012 16:40:34 +0200
From: David Sterba <dave@jikos.cz>
To: dg1727 <dg1727@hushmail.com>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: How to get Btrfs on 2nd partition of USB HDD to automount as
 read/write
Message-ID: <20120822144034.GS17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120821153618.GM17430@twin.jikos.cz>
 <20120821192822.90CF1A6E3F@smtp.hushmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120821192822.90CF1A6E3F@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2012 at 03:28:22PM -0400, dg1727 wrote:
> Thanks a lot for these answers.  As an exercise, how would I track 
> that patch so I can tell when it has been released?  Pointing me to 
> a webpage that covers this would be fine.  

You can easily check that the patch appears in the main progs repo at

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=summary

or you can clone the repo and check the git log directly.


david
