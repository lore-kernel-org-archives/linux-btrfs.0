Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:49203 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395AbaKMRuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 12:50:46 -0500
Received: by mail-la0-f49.google.com with SMTP id ge10so13344147lab.8
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 09:50:45 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan.2014.11.13.17.43.12@googlemail.com>
References: <1415897993-7556-1-git-send-email-fdmanana@suse.com>
	<pan.2014.11.13.17.33.19@googlemail.com>
	<pan.2014.11.13.17.43.12@googlemail.com>
Date: Thu, 13 Nov 2014 17:50:44 +0000
Message-ID: <CAL3q7H60L=5-w4377ddhrpbN3yDXAX_e9iCrtWPTxHHsus-OYw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: don't ignore log btree writeback errors
From: Filipe David Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 13, 2014 at 5:43 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On Thu, 13 Nov 2014 17:33:19 +0000, Holger Hoffstätte wrote:
>
>> On Thu, 13 Nov 2014 16:59:53 +0000, Filipe Manana wrote:
>>
>>> If an error happens during writeback of log btree extents, make sure the
>>> error is returned to the caller (fsync), so that it takes proper action
>>> (commit current transaction) instead of writing a superblock that points
>>> to log btrees with all or some nodes that weren't durably persisted.
>>>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>  fs/btrfs/tree-log.c | 21 +++++++++++++++------
>>>  1 file changed, 15 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>>> index 6d58d72..c8274d3 100644
>>> --- a/fs/btrfs/tree-log.c
>>> +++ b/fs/btrfs/tree-log.c
>>> @@ -2599,12 +2599,14 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>>>      index2 = root_log_ctx.log_transid % 2;
>>>      if (atomic_read(&log_root_tree->log_commit[index2])) {
>>>              blk_finish_plug(&plug);
>>> -            btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
>>> +            ret = btrfs_wait_marked_extents(log, &log->dirty_log_pages,
>>> +                                            mark);
>>>              wait_log_commit(trans, log_root_tree,
>>>                              root_log_ctx.log_transid);
>>>              btrfs_free_logged_extents(log, log_transid);
>>>              mutex_unlock(&log_root_tree->log_mutex);
>>> -            ret = root_log_ctx.log_ret;
>>> +            if (!ret)
>>> +                    ret = root_log_ctx.log_ret;
>>>              goto out;
>>>      }
>>>      ASSERT(root_log_ctx.log_transid == log_root_tree->log_transid);
>>
>> This first hunk didn't apply to my 3.14.x tree that is 99.999% in sync with
>> btrfs-3.18+, as a line is missing from the context. See:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/tree/fs/btrfs/tree-log.c?h=for-linus#n2605
>>
>> Any idea where that missing btrfs_free_logged_extents() went?
>
> Found it: it went away with Josef's recent patch on Nov 6:
> "Btrfs: make sure we wait on logged extents when fsycning two subvols"
> (http://permalink.gmane.org/gmane.comp.file-systems.btrfs/40005)
>
> ..which I have applied. boohoo.
>
> That patch also adds another call to btrfs_wait_marked_extents(), which should
> then probably also have its return value handled?

No, it's a different call - btrfs_wait_logged_extents().

>
> thanks,
> Holger
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
