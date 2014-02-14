Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:37339 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaBNNjZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 08:39:25 -0500
Received: by mail-bk0-f45.google.com with SMTP id mz13so210823bkb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 05:39:24 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140214134656.7c1f2544@plati.site>
References: <1391769341-20688-1-git-send-email-ddiss@suse.de>
	<20140214134656.7c1f2544@plati.site>
Date: Fri, 14 Feb 2014 13:39:24 +0000
Message-ID: <CAL3q7H7f0xSnny1B75bhztsYxM1n92aUpNDqwTaF60BVGo2zFA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] __btrfs_drop_extents() BUG_ON reproducer
From: Filipe David Manana <fdmanana@gmail.com>
To: David Disseldorp <ddiss@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 14, 2014 at 12:46 PM, David Disseldorp <ddiss@suse.de> wrote:
> Ping, any Btrfsers get a chance to look at this patch series?
> I'd like to get it into the QA tree.

If no one else gets there first, I'll take a look at it soon.
thanks

>
> On Fri,  7 Feb 2014 11:35:38 +0100, David Disseldorp wrote:
>
>> This patch-set provides a reproducer for hitting the 3.14.0-rc1 BUG_ON()
>> at:
>>  692 int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
>> ...
>>  839                 /*
>>  840                  *  | ---- range to drop ----- |
>>  841                  *      | -------- extent -------- |
>>  842                  */
>>  843                 if (start <= key.offset && end < extent_end) {
>>  844                         BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
>>  845
>>  846                         memcpy(&new_key, &key, sizeof(new_key));
>>
>> The first patch adds a small cloner binary which is used by btrfs/035 to
>> dispatch BTRFS_IOC_CLONE_RANGE requests.
>>
>> This workload resembles that of Samba's vfs_btrfs module, when a Windows
>> client restores a file from a shadow-copy (snapshot) using server-side
>> copy requests.
>>
>> Changes since V2:
>> - Remove explicit write error checks
>>
>> Changes since V1:
>> - Use strtoull instead of atoi
>> - Print error conditions in cloner
>> - Check for cloner binary before running test
>> - Continue test on failure
>> - Add cloner to .gitignore
>>
>> Feedback appreciated.
>>
>> Cheers, David
>>
>>
>>  .gitignore          |   1 +
>>  configure.ac        |   1 +
>>  src/Makefile        |   2 +-
>>  src/cloner.c        | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/035     |  77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/035.out |   3 +++
>>  tests/btrfs/group   |   1 +
>>  7 files changed, 276 insertions(+), 1 deletion(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
