Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50130 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab3LTMhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 07:37:17 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]) by mail.gmx.com
 (mrgmx102) with ESMTPSA (Nemesis) id 0MATlG-1Vnti52C4I-00BabO for
 <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2013 13:37:15 +0100
Received: by mail-pb0-f45.google.com with SMTP id rp16so2564416pbb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2013 04:37:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387483201.23881.2.camel@ret.masoncoding.com>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
 <1387483201.23881.2.camel@ret.masoncoding.com>
From: eb <eab@gmx.ch>
Date: Fri, 20 Dec 2013 13:36:53 +0100
Message-ID: <CAFvEZVFwzKUBbBC9-3CaX0SL56qnX3rizOqiJwZrs60cMoN8-Q@mail.gmail.com>
Subject: Re: btrfs on bcache
To: Chris Mason <clm@fb.com>
Cc: linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 19, 2013 at 8:59 PM, Chris Mason <clm@fb.com> wrote:
> On Wed, 2013-12-18 at 18:17 +0100, eb wrote:
> Btrfs shouldn't be setting the offset on the bios.  Are you able to add
> a WARN_ON to the message that prints this so we can see the stack trace?

If you send me a patch - my experience on hacking on the kernel is
exactly 0 - I'll try to see if I can compile a custom kernel and get
it running.

> Could you please cc the bcache and btrfs list together?

Done.

I did some more testing - I copied an image of a 128GB drive over the
network (via netcat) onto the bcache/btrfs system and verified the
results twice using sha1sum. They're both identical on the source
system (which is *not* using bcache) and bcache/btrfs setup. I've
gotten a lot of the incomplete write errors and a few csum erros in
dmesg, but apparently they haven't done any harm?

Not sure how remarkable this is, as these kinds of things are supposed
to bypass the cache anyway, but I assume they still have to go through
the subsystem.
