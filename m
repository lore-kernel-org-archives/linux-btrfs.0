From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: inc iversion whenever we modify ctime
Date: Wed, 11 Apr 2012 20:16:01 +0200
Message-ID: <20120411181601.GA23876@twin.jikos.cz>
References: <1334165137-3016-1-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334165137-3016-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 01:25:37PM -0400, Josef Bacik wrote:
> The cthon tests are failing some because the iversion didn't change whenever
> we do some operations.  Basically iversion needs to change anytime the ctime
> would have changed, so go through and make everybody change their iversion
> if we change their ctime.  Thanks,

IMHO it makes sense to fold the changes into

  "Btrfs: use i_version instead of our own sequence"

david
