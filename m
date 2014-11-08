Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:42234 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaKHHRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Nov 2014 02:17:16 -0500
Received: by mail-la0-f43.google.com with SMTP id ge10so5529880lab.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 23:17:14 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <545D714B.2000207@pobox.com>
References: <1415392765-1877-1-git-send-email-fdmanana@suse.com>
	<1415408514-17845-1-git-send-email-fdmanana@suse.com>
	<545D714B.2000207@pobox.com>
Date: Sat, 8 Nov 2014 07:17:14 +0000
Message-ID: <CAL3q7H5hXg6J+ON7Ak7TYbXim8GdECMhTCsXiEf++_MyZ9pKhw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: make xattr replace operations atomic
From: Filipe David Manana <fdmanana@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 8, 2014 at 1:26 AM, Robert White <rwhite@pobox.com> wrote:
> On 11/07/2014 05:01 PM, Filipe Manana wrote:
>>
>> V2: Added missing btrfs_mark_buffer_dirty() call for the case where a
>> replace
>>      happens for an item with no other xattrs and the new xattr value size
>> is
>>      the same as the old xattr value size;
>>      Made btrfs_search_slot not release the path if it returns EOVERFLOW
>> (from
>>      split_leaf), so that we can get the current size of the item when
>> doing
>>      the replace and extend the leaf to a size smaller then what we passed
>> to
>>      btrfs_search_slot if the xattr exists in the item (and the new extend
>> size
>>      is new_size - old_size, excluding xattr's name and sizeof struct
>> btrfs_dir_item).
>
>
> Stupid Question Here: How does this "replace and extend" affect the whole
> copy-on-write paradigm. Aren't you now overwriting the contents of the old
> data instead of doing a COW?

Btree nodes are always COWed.

>
> Not a passive-aggressive commentary question, I genuinely don't understand
> this piece of code so I am seeking a learning opportunity.
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
