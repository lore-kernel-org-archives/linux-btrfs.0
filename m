Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:53855 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaH2Swe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 14:52:34 -0400
Received: by mail-la0-f50.google.com with SMTP id mc6so3240066lab.9
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Aug 2014 11:52:33 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140829145130.GA14038@infradead.org>
References: <1409315868-29734-1-git-send-email-fdmanana@suse.com>
	<20140829145130.GA14038@infradead.org>
Date: Fri, 29 Aug 2014 19:52:33 +0100
Message-ID: <CAL3q7H7Qo0TiSUwZX+GbnsEpwEea6eFQJ_KPyM_O2PkTjKmVjA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix crash while a ranged msync() is ongoing
From: Filipe David Manana <fdmanana@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 29, 2014 at 3:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Aug 29, 2014 at 01:37:48PM +0100, Filipe Manana wrote:
>> After the commit 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8 (titled
>> "mm/msync.c: sync only the requested range in msync()"), our fsync
>> callback can be called with a range that covers only part of the
>> file and not the whole file anymore.
>
> Not that there have been other users of range fsyncs around for a long
> time.  The SCSI target code is one, the NFS server another, and last but
> not least generic_write_sync() which is used by most filesystems
> including btrfs to implement O_SYNC writes.

Point taken Christoph, this isn't specific to msync nor impossible to
happen before 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8.
I'll update the commit log to reflect that.

Thanks for looking.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
