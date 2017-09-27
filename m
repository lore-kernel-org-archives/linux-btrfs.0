Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751016AbdI0QWH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 12:22:07 -0400
Date: Wed, 27 Sep 2017 18:20:32 +0200
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: kreijack@inwind.it, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
Message-ID: <20170927162032.GM31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
 <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
 <5e079410-cd64-3d40-8914-b3d48ecdebfd@gmail.com>
 <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
 <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
 <c0652f30-5ca7-b917-7f15-78dfdb2e1205@libero.it>
 <7af34399-f969-dfe5-d006-3e7fb293b9df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7af34399-f969-dfe5-d006-3e7fb293b9df@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 25, 2017 at 07:15:30AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-09-24 10:08, Goffredo Baroncelli wrote:
> > On 09/24/2017 12:10 PM, Anand Jain wrote:

A lot of points in this thread, let me address them here.

I don't want to remove --rootdir functionality, the fix that's being
proposed removes the minimalization -- feature that was not well known,
but I understand it's useful (and already used).

I'd like to fix that in another way, eg. as an option to mkfs or a
separate tool.

I'm not worried about adding more code or code complexity. If we do it
right it's not a problem in the long run. But people for some reason
like to delete other people's code or functionality.

Regarding guessing number of users, this is always hard. So if there's
one vocal enough to let us know about the usecase, it's IMHO good time
to explore the it, code-wise and documentation-wise, and fix it or
improve.

So, what next. I'd like to get rid of the custom chunk allocator, namely
because of the known 1MB area misuse and duplication.

Implementing the minimalization might need some preparatory work and I
don't have a realistic ETA now. Ideally we'd fix both problems in one
version, as I'd rather avoid "temporary" solution to drop the
minimalization with the promise to put it back later.
