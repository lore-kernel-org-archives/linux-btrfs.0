Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52064 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbcIIOmY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 10:42:24 -0400
Date: Fri, 9 Sep 2016 16:40:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Some help with the code.
Message-ID: <20160909144046.GU16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAKinxcXinpdj5ZNrXSBegLn+2LnbYtwChX=3wBP_UELSPa+yig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKinxcXinpdj5ZNrXSBegLn+2LnbYtwChX=3wBP_UELSPa+yig@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2016 at 04:22:25PM +0100, Tomasz Kusmierz wrote:
> This is predominantly for maintainers:
> 
> I've noticed that there is a lot of code for btrfs ... and after few
> glimpses I've noticed that there are occurrences which beg for some
> refactoring to make it less of a pain to maintain.
> 
> I'm speaking of occurrences where:
> - within a function there are multiple checks for null pointer and
> then whenever there is anything hanging on the end of that pointer to
> finally call the function, pass the pointer to it and watch it perform
> same checks to finally deallocate stuff on the end of a pointer.

Can you please point me to an example? If it's a bad pattern it would be
worth cleaning up.

> - single line functions ... called only in two places

That might not be always useless, as the function name tells us what it
does, not how, so it's a form of selfdocumenting code. If the function
body is some common code construct, it would be harder to grep for it.

But I understand what you mean. This could be also a leftover from some
broader changes that removed calls, reduced function size to the
one line.

> and so on.
> 
> I know that you guys are busy, but maintaining code that is only
> growing must be a pain.

Depends. Standalone features bring a lot of new code, but it's
separated. Random sample of patches from recent releases tells me that
net line growth is spread accross many patches that add just a few lines
(eg. enhanced tests, more helpers).

https://btrfs.wiki.kernel.org/index.php/Contributors#Statistics

Doing broader cleanups is good when done from time to time, as it tends
to interfere with other patches, so it's more a matter of scheduling
when to do it. The beginning or end of the particular development cycle
are good candidates.

Reducing size should be done in the way that does not make the code less
readable, which is kind of subjective metric but should be sorted when
patches (or samples) are posted. That said, cleanups and refactoring
patches are welcome.
