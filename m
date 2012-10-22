Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56491 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753494Ab2JVGlw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 02:41:52 -0400
Message-ID: <5084EAAD.4090806@gmx.net>
Date: Mon, 22 Oct 2012 08:41:49 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dave@jikos.cz>,
        Rory Campbell-Lange <rory@campbell-lange.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Fits: tool to parse stream
References: <1350048772-20658-1-git-send-email-sensille@gmx.net> <50791203.6060406@gmx.net> <20121013080857.GA1491@campbell-lange.net> <20121013154128.GA10679@twin.jikos.cz> <20121015143222.GA31310@shiny>
In-Reply-To: <20121015143222.GA31310@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15.10.2012 16:32, Chris Mason wrote:
> On Sat, Oct 13, 2012 at 09:41:28AM -0600, David Sterba wrote:
>> On Sat, Oct 13, 2012 at 09:08:57AM +0100, Rory Campbell-Lange wrote:
>>> Perhaps "BTRFS Incremental Stream" or "Backup Incremental Stream" should
>>> be considered, with the file extension ".bis".
>>
>> From the brainstorming we had about the name, the intention behind the
>> stream is to be filesystem independent.
>>
>> So this might be named FIS with .fis extension, that is not far from the
>> proposed name. However, this hasn't been approved by the Slang committee
>> yet :)
> 
> urbandictionary has some entries for fis, although I'm not really sure
> that matters.  .fs is still my favorite, or .fss if you want to have the
> word stream in there.

We finally settled on 'far', Filesystem Agnostic Replication.

-Arne

> 
> The stream parser is really cool though, thanks Arne.
> 
> -chris
> 
