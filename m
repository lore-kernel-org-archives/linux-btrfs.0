Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glockenspiel.complete.org ([78.47.53.23]:35998 "EHLO
	glockenspiel.complete.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3JUNr4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 09:47:56 -0400
Message-ID: <52653084.8050106@complete.org>
Date: Mon, 21 Oct 2013 08:47:48 -0500
From: John Goerzen <jgoerzen@complete.org>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Lots of trouble hanging when rm files with many extents
References: <20131021133644.172387f5@virtall.com>
In-Reply-To: <20131021133644.172387f5@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/20/2013 11:36 PM, Tomasz Chmielewski wrote:
>>> I'll do some more tests with lots of extents to see if it's
>>> reproducible here as well.
>> Interestingly, I've generally had qgroups enabled here as well,
>> possibly on all of these systems.  Could that be the culprit?
> Possibly.
>
> Is there a reliable way to create files with many extents? I've tried
> playing with fallocate, but couldn't create files with too many extents
> with it.
I could do it quite reliably by storing a VirtualBox VM hard drive image 
there, then running a Windows Update inside the VM.  Instant 
fragmentation ;-)

Another approach could probably be to write a C program that writes 20GB 
to a file, then seeks to random places within it, writing chunks of data 
within them.

I could probably whip up such a thing if the debuggers need it.

John
