Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:43965 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2JMM34 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 08:29:56 -0400
Date: Sat, 13 Oct 2012 09:08:57 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fits: tool to parse stream
Message-ID: <20121013080857.GA1491@campbell-lange.net>
References: <1350048772-20658-1-git-send-email-sensille@gmx.net>
 <50791203.6060406@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50791203.6060406@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/10/12, Arne Jansen (sensille@gmx.net) wrote:
> On 10/12/12 15:32, Arne Jansen wrote:
> 
> > The idea of the btrfs send stream format was to generate it in a way that
> > it is easy to receive on different platforms. Thus the proposed name FITS, for
> > Filesystem Incremental Backup Stream. We should also build the tools to
> > receive the stream on different platforms.
> 
> I meant to write 'Filesystem Incremental Transport Stream', but, as
> Andrey Kuzmin pointed out, the name FITS is already taken. As the
> 'Backup' slipped in somehow, FIBS might be an alternative. Any
> thoughts?

Perhaps "BTRFS Incremental Stream" or "Backup Incremental Stream" should
be considered, with the file extension ".bis".

The word "bis" is also, according to Wikipedia, "...a prefix of suffix
designating the second instance of a thing...", which seems largely
appropriate.
http://en.m.wikipedia.org/wiki/BIS

Rory

-- 
Rory Campbell-Lange
rory@campbell-lange.net
