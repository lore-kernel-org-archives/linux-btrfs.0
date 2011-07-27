From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 7/7] btrfs: don't BUG_ON allocation errors in btrfs_drop_snapshot
Date: Wed, 27 Jul 2011 13:49:50 -0400
Message-ID: <1311788976-sup-6825@shiny>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com> <1310681702-13922-2-git-send-email-mfasheh@suse.com> <1310681702-13922-3-git-send-email-mfasheh@suse.com> <1310681702-13922-4-git-send-email-mfasheh@suse.com> <1310681702-13922-5-git-send-email-mfasheh@suse.com> <1310681702-13922-6-git-send-email-mfasheh@suse.com> <1310681702-13922-7-git-send-email-mfasheh@suse.com> <1310681702-13922-8-git-send-email-mfasheh@suse.com> <4E1FAE4E.5030508@jp.fujitsu.com> <20110718220919.GC6911@wotan.suse.de> <4E24CAD0.2030702@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Mark Fasheh <mfasheh@suse.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E24CAD0.2030702@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tsutomu Itoh's message of 2011-07-18 20:07:44 -0400:
> Hi, Mark,
> 
> (2011/07/19 7:09), Mark Fasheh wrote:
> > On Fri, Jul 15, 2011 at 12:04:46PM +0900, Tsutomu Itoh wrote:
> >> (2011/07/15 7:15), Mark Fasheh wrote:
> >>> In addition to properly handling allocation failure from btrfs_alloc_path, I
> >>> also fixed up the kzalloc error handling code immediately below it.
> >>
> >> Need not you correct the caller of btrfs_drop_snapshot()?
> > 
> > Hmm, I don't think so - the only two callers of btrfs_drop_snapshot() are merge_reloc_roots() and
> > btrfs_clean_old_snapshots(). Both of which currently ignore the return code.
> 
> If you think so, I think that you should change the type of btrfs_drop_snapshot()
> into 'void'.

In both of these cases we should be forcing the FS readonly instead.

-chris
