Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:42131 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbeD0XYH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 19:24:07 -0400
Received: by mail-oi0-f54.google.com with SMTP id t27-v6so2992661oij.9
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 16:24:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180427205313.GM5965@thunk.org>
References: <CA+EzBbC7rmYsKjy_+rkwJLK-bmU51q+a4rnezvOoZYyJ8kWGqg@mail.gmail.com>
 <34B2B717-B12D-44F4-B0D0-E3D606BBEFA6@fb.com> <CA+EzBbBaZjcdHi4O4W8LZ2JvpYhN_hFGvktaeFYRfSygW3sK7A@mail.gmail.com>
 <20180427160740.GD21272@twin.jikos.cz> <1A75793D-6487-4EE6-9F4D-AD538D7283CA@fb.com>
 <20180427205313.GM5965@thunk.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 27 Apr 2018 17:24:06 -0600
Message-ID: <CAJCQCtTS3zohwC+xCA7GdoB=EgPD9+k9wHOGLGnF+V-+RLs-NA@mail.gmail.com>
Subject: Re: Inconsistent behavior of fsync in btrfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Filipe Manana <fdmanana@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 2:53 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:

> It seems to me that it would be desirable if all of the major file
> systems have roughly the same minimum guarantee for fsync(2), so that
> application writers don't have to make file-system specific
> assumptions.  In general the goal ought to be "the right thing" should
> happen.

Yes please.

I'd also like to know about sync() differences as well, as I've found
not through code eval but through testing that file systems differ in
sync() behavior as well.


-- 
Chris Murphy
