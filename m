From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 7/7] btrfs: don't BUG_ON allocation errors in btrfs_drop_snapshot
Date: Tue, 19 Jul 2011 09:07:44 +0900
Message-ID: <4E24CAD0.2030702@jp.fujitsu.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com> <1310681702-13922-2-git-send-email-mfasheh@suse.com> <1310681702-13922-3-git-send-email-mfasheh@suse.com> <1310681702-13922-4-git-send-email-mfasheh@suse.com> <1310681702-13922-5-git-send-email-mfasheh@suse.com> <1310681702-13922-6-git-send-email-mfasheh@suse.com> <1310681702-13922-7-git-send-email-mfasheh@suse.com> <1310681702-13922-8-git-send-email-mfasheh@suse.com> <4E1FAE4E.5030508@jp.fujitsu.com> <20110718220919.GC6911@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110718220919.GC6911@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Mark,

(2011/07/19 7:09), Mark Fasheh wrote:
> On Fri, Jul 15, 2011 at 12:04:46PM +0900, Tsutomu Itoh wrote:
>> (2011/07/15 7:15), Mark Fasheh wrote:
>>> In addition to properly handling allocation failure from btrfs_alloc_path, I
>>> also fixed up the kzalloc error handling code immediately below it.
>>
>> Need not you correct the caller of btrfs_drop_snapshot()?
> 
> Hmm, I don't think so - the only two callers of btrfs_drop_snapshot() are merge_reloc_roots() and
> btrfs_clean_old_snapshots(). Both of which currently ignore the return code.

If you think so, I think that you should change the type of btrfs_drop_snapshot()
into 'void'.

Thanks,
Tsutomu

> 	--Mark
> 
> --
> Mark Fasheh
> 
> 

