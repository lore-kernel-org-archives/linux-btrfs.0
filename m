Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932268AbcKBXdo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 19:33:44 -0400
Date: Thu, 3 Nov 2016 00:33:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Lukas Lueg <lukas.lueg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: State of the fuzzer
Message-ID: <20161102233340.GI12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJF-kYmnBt6yRLJ+R3HdJ03oqp_ptwXpat40vXoD_b=MUvJZUw@mail.gmail.com>
 <20160909140059.GT16983@twin.jikos.cz>
 <CAJF-kYnXjz_dg2eev3WUqg3=XTBX=W8e2qnLQKtpnC6cCHvR+Q@mail.gmail.com>
 <CAJF-kYkG77sAQ4VOqX+Fovu+fO6WKVMZmUA8WG+uMU5EM2ZwUg@mail.gmail.com>
 <CAJF-kYk_a6hwgbQRw+9yBb54hXxC49LAZVs25FnoHm+zosFMww@mail.gmail.com>
 <CAJF-kYnH+cORfSLGx1Wb6S4iPDjnJxYOwm2trC_FbOK8t7bPVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJF-kYnH+cORfSLGx1Wb6S4iPDjnJxYOwm2trC_FbOK8t7bPVQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Oct 11, 2016 at 02:07:48PM +0200, Lukas Lueg wrote:
> I've now shut down all fuzzer nodes since they only cost money and
> there is no progress on most of the aforementioned bugs.

sorry, I didn't know there are cost implications. I've triaged the bugs
some time ago and tried to fix one of the underlying problems that would
probably close serveal bugs, but it turned out to be not that easy.

There's not that much interest in k.org bugs from other developers and I
have to split my time among several tasks or keep up with release
schedules.

I appreciate that you took the time to do the tests and reports, I'll
get to them eventually. I also hope you're not discouraged from further
testing. This would make best sense only after all current fuzzer bugs
are fixed, but I can't give you an ETA.
