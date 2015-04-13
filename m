Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbbDMOrp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:47:45 -0400
Date: Mon, 13 Apr 2015 16:47:43 +0200
From: David Sterba <dsterba@suse.cz>
To: harshad shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [GSoC 2015] Btrfs content based storage
Message-ID: <20150413144743.GL25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAD+ocbzxMXNGYKOmUNnVfj297brVsyjQ=vPGs7hJ_9aHNOhdVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD+ocbzxMXNGYKOmUNnVfj297brVsyjQ=vPGs7hJ_9aHNOhdVA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 27, 2015 at 10:58:42AM -0400, harshad shirwadkar wrote:
> I am a CS graduate student from Carnegie Mellon University. I am
> hoping to build the feature - "Content based storage mode" under
> Google Summer of Code 2015. This project has also been listed as an
> idea on BTRFS ideas page. However, I have not found a mentor yet, and
> without a mentor I can not participate in the program. Please let me
> know if anybody is interested in mentoring this project. Here is a
> link to my proposal:
> 
> http://harshadjs.github.io/2015/03/27/Fedora-BTRFS-Content-Storage-Mode/

This probably has a significant overlap with the in-band dedup work from
Liu bo [1]. Your proposal expects an interface to look up the data by
hash which hasn't been implemented afaik.

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/34097 (v10)
