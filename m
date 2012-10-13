Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44134 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab2JMPlb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 11:41:31 -0400
Date: Sat, 13 Oct 2012 17:41:28 +0200
From: David Sterba <dave@jikos.cz>
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fits: tool to parse stream
Message-ID: <20121013154128.GA10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1350048772-20658-1-git-send-email-sensille@gmx.net>
 <50791203.6060406@gmx.net>
 <20121013080857.GA1491@campbell-lange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121013080857.GA1491@campbell-lange.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 13, 2012 at 09:08:57AM +0100, Rory Campbell-Lange wrote:
> Perhaps "BTRFS Incremental Stream" or "Backup Incremental Stream" should
> be considered, with the file extension ".bis".

>From the brainstorming we had about the name, the intention behind the
stream is to be filesystem independent.

So this might be named FIS with .fis extension, that is not far from the
proposed name. However, this hasn't been approved by the Slang committee
yet :)

david
