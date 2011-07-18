From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 7/7] btrfs: don't BUG_ON allocation errors in btrfs_drop_snapshot
Date: Mon, 18 Jul 2011 15:09:19 -0700
Message-ID: <20110718220919.GC6911@wotan.suse.de>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com> <1310681702-13922-2-git-send-email-mfasheh@suse.com> <1310681702-13922-3-git-send-email-mfasheh@suse.com> <1310681702-13922-4-git-send-email-mfasheh@suse.com> <1310681702-13922-5-git-send-email-mfasheh@suse.com> <1310681702-13922-6-git-send-email-mfasheh@suse.com> <1310681702-13922-7-git-send-email-mfasheh@suse.com> <1310681702-13922-8-git-send-email-mfasheh@suse.com> <4E1FAE4E.5030508@jp.fujitsu.com>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1FAE4E.5030508@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2011 at 12:04:46PM +0900, Tsutomu Itoh wrote:
> (2011/07/15 7:15), Mark Fasheh wrote:
> > In addition to properly handling allocation failure from btrfs_alloc_path, I
> > also fixed up the kzalloc error handling code immediately below it.
> 
> Need not you correct the caller of btrfs_drop_snapshot()?

Hmm, I don't think so - the only two callers of btrfs_drop_snapshot() are merge_reloc_roots() and
btrfs_clean_old_snapshots(). Both of which currently ignore the return code.
	--Mark

--
Mark Fasheh
