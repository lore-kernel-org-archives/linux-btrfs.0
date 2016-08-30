Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757848AbcH3LLR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 07:11:17 -0400
Date: Tue, 30 Aug 2016 13:09:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Lukas Lueg <lukas.lueg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Multiple bugs found by fuzzing BTRFS
Message-ID: <20160830110955.GA16983@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
 <20160829170220.GY16983@twin.jikos.cz>
 <CAJF-kYkQv11XCzcMfP02yw2AnO4LssbVDLuTqzZqB9ddeCCaow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJF-kYkQv11XCzcMfP02yw2AnO4LssbVDLuTqzZqB9ddeCCaow@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 29, 2016 at 08:47:10PM +0200, Lukas Lueg wrote:
> I'll report new issues to bz as they turn up from the current round
> only if they represent a yet unreported kind of problem (e.g. there
> are stack-based buffer over- and underruns lurking, I lost them due to
> a bug in my setup, though). The next round will be much faster as I've
> now vastly improved my automatic bug triage and fuzzing speed.
> 
> I lost interest once after bugs went unanswered - there are bugs still
> open and unanswered from 2015/04. I hope this won't be a problem this
> time.

Yeah, the lack if replies is unfortunate and happens. There's a
disproportion between number of people who report bugs and who go
through them and fix.  I personally look out for the fuzzing bugs as
they usually come with an image and it's easy to create a testcase from
them, reproducible bugs also tend to get fixes faster.

I must have missed the bugs though, there are 3 fuzzed images, reported
by you in bugs 96971, 97191 and 97271. I see two more (97031 and 97021)
and will look into them.
