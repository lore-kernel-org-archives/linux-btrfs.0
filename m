Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.39.gs ([212.13.216.70]:50717 "EHLO mail.39.gs"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab3EKQ5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 12:57:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 11 May 2013 17:57:11 +0100
From: Tim Eggleston <lists@timeggleston.co.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Defragmentation of large files
In-Reply-To: <2041896.zZaOgtZsWg@merkaba>
References: <7f41ae131c619b653da281429fcead79@mail.39.gs>
 <2041896.zZaOgtZsWg@merkaba>
Message-ID: <fa5698cdba14a3164f014a8c386bc837@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Yes. The command just triggers the defragmentation which takes place 
> in the
> background. Try a "sync" afterwards :)

Sorry Martin, I should have specified that I wondered if it was like 
the scrub operation in that respect, so I left it several hours before 
running filefrag again (and seeing that the number of extents was 
unchanged). Top and iostat also don't report any particular activity 
immediately after running the defrag command, so it doesn't look like 
much if anything is happening.

By the way, this is on a filesystem mounted with -o autodefrag, 
although per the docs I wasn't expecting the auto defragmentation to 
work with the big VM images.
