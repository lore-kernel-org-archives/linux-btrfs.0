Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34483 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbDAIdq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 04:33:46 -0400
Received: by igcau2 with SMTP id au2so27269884igc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 01:33:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <551B9333.8070805@oracle.com>
References: <1427829524-23946-1-git-send-email-fdmanana@suse.com>
	<1427843497-7733-1-git-send-email-fdmanana@suse.com>
	<551B9333.8070805@oracle.com>
Date: Wed, 1 Apr 2015 09:33:45 +0100
Message-ID: <CAL3q7H7y=WGa-XBp8GTggZw2vbpfh_kjwnqx+ybBTW_jF2Qd9w@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: add debugfs file to test transaction aborts
From: Filipe David Manana <fdmanana@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 7:41 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
>
>> +bool debugfs_abort_transaction(struct btrfs_fs_info *fs_info)
>> +{
>> +       if (!btrfs_debugfs_label_trans_abort[0])
>> +               return false;
>> +       return strcmp(fs_info->super_copy->label,
>> +                     btrfs_debugfs_label_trans_abort) == 0;
>> +}
>> +
>
>
>  label is not mandatory to be present.
>
>  did I missing something ?

Yes. It's intentional.
This is for testing purposes only, not for users.

thanks

>
> Thanks, Anand
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
