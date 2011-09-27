From: David Sterba <dave@jikos.cz>
Subject: Re: [GIT PULL] ENOSPC rework and random fixes for next merge window
Date: Tue, 27 Sep 2011 17:01:17 +0200
Message-ID: <20110927150117.GF22205@twin.jikos.cz>
References: <1317072992-28375-1-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317072992-28375-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2011 at 05:36:32PM -0400, Josef Bacik wrote:
>       Btrfs: fix how we mount subvol=<whatever>

this patch was not sent to the mailiglist, although this is an
intersting change from the user's POV:

subvolumes are now mountable via

-o subvol=any/path/always/relative/to/toplevel

which makes subvolrootid obsolete and fixes the mess with set-default
and subvol= mounts.


hooray,
d/
