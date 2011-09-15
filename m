From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 0/20] btrfs: More error handling fixes
Date: Thu, 15 Sep 2011 20:03:36 +0200
Message-ID: <20110915180336.GG22205@twin.jikos.cz>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Sep 15, 2011 at 10:34:39AM -0700, Mark Fasheh wrote:
> Some of the patches (the first 8) were previously sent to this list but got
> no comments so I'm resending them with this set. Changes from last time are
> that I also started setting the file system readonly on errors which look
> like possible corruption.

I've been testing your branch 'all_fixes' from your git.k.org repo for
some time, among other patchsets and fixes in my development repository
at http://repo.or.cz/w/linux-2.6/btrfs-unstable.git #integration/btrfs-next
and I have not hit any single problem which would point back to your patches.
I'm testing with xfstests and various hand-made stress tests for specific
areas (usually from reports on irc).


HTH,
david
