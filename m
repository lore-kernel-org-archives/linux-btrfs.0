From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: detect wether a device supports discard
Date: Thu, 04 Aug 2011 16:35:17 -0400
Message-ID: <1312490077-sup-9824@shiny>
References: <1312469547-7816-1-git-send-email-josef@redhat.com> <20110804200054.GG28122@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110804200054.GG28122@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-08-04 16:00:54 -0400:
> just for the record: this issue has been reported and a patch is
> awaiting inclusion:
> 
> https://patchwork.kernel.org/patch/791822/ (report & discussion)
> https://patchwork.kernel.org/patch/915502/ (last update)

Right, Josef's patch adds a small incremental fix over those.  I'm
sending them in with the pile of bug fixes for rc2.

-chris
