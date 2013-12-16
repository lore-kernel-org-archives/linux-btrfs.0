Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65156 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3LPMvD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 07:51:03 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so2042745wib.14
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 04:51:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131213010751.GV6498@twin.jikos.cz>
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
 <1386805122-23972-8-git-send-email-sekharan@us.ibm.com> <20131213010751.GV6498@twin.jikos.cz>
From: saeed bishara <saeed.bishara@gmail.com>
Date: Mon, 16 Dec 2013 14:50:41 +0200
Message-ID: <CAMAG_eeg1-Ewj7UcppYcZkZ23tFCXL=f=Bu1zMfDeMR2-t4oMg@mail.gmail.com>
Subject: Re: [PATCH 7/7] btrfs: subpagesize-blocksize: Allow mounting
 filesystems where sectorsize != PAGE_SIZE
To: dsterba@suse.cz, Chandra Seetharaman <sekharan@us.ibm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 3:07 AM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Dec 11, 2013 at 05:38:42PM -0600, Chandra Seetharaman wrote:
>> This is the final patch of the series that allows filesystems with
>> blocksize smaller than the PAGE_SIZE.
>
>> -     if (sectorsize != PAGE_SIZE) {
>
> You've implemented the sectorsize < PAGE_SIZE part (multiple extent
> buffers per page), so the check should stay as:
>
>         if (sectorsize > PAGE_SIZE) {
>
please add a check that PAGE_SIZE/sectorsize <= MAX_EXTENT_BUFFERS_PER_PAGE
also, can you please add kernel log message when you have subpage block size?

>> -             printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
>> -                    "found on %s\n", (unsigned long)sectorsize, sb->s_id);
>> -             goto fail_sb_buffer;
>> -     }
>> -
>>       mutex_lock(&fs_info->chunk_mutex);
>>       ret = btrfs_read_sys_array(tree_root);
>>       mutex_unlock(&fs_info->chunk_mutex);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
