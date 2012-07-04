Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46165 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2GDTt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 15:49:57 -0400
Received: by pbbrp8 with SMTP id rp8so11497758pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 12:49:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvaMx-nOd8BWHg_6S=FXvvGcEEp=A-BkpsMgO4cwLKgFug@mail.gmail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-6-git-send-email-ablock84@googlemail.com>
	<CAHf9xvaMx-nOd8BWHg_6S=FXvvGcEEp=A-BkpsMgO4cwLKgFug@mail.gmail.com>
Date: Wed, 4 Jul 2012 21:49:56 +0200
Message-ID: <CAB9VWqAQvVGW_pMcWceTxbeVX8SXHUPi226Yms7w9Riq2RU2Og@mail.gmail.com>
Subject: Re: [RFC PATCH 5/7] Btrfs: add btrfs_compare_trees function
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 4, 2012 at 8:27 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Hi Alex,
>
>> +                       spin_lock(&left_root->root_times_lock);
>> +                       ctransid = btrfs_root_ctransid(&left_root->root_item);
>> +                       spin_unlock(&left_root->root_times_lock);
>> +                       if (ctransid != left_start_ctransid)
>> +                               left_start_ctransid = 0;
>> +
>> +                       spin_lock(&right_root->root_times_lock);
>> +                       ctransid = btrfs_root_ctransid(&right_root->root_item);
>> +                       spin_unlock(&right_root->root_times_lock);
>> +                       if (ctransid != right_start_ctransid)
>> +                               left_start_ctransid = 0;
> Shouldn't it be here right_start_ctransid=0? Otherwise,
> right_start_ctransid is pretty useless in this function.
>
Hmm you're right, it should be right_start_ctransid. However...the
code was working by accident because the next if does check for left
and right :)
Fixed that in my git repo.
>> +
>> +                       if (!left_start_ctransid || !right_start_ctransid) {
>> +                               WARN(1, KERN_WARNING
>> +                                       "btrfs: btrfs_compare_tree detected "
>> +                                       "a change in one of the trees while "
>> +                                       "iterating. This is probably a "
>> +                                       "bug.\n");
>> +                               ret = -EIO;
>> +                               goto out;
>> +                       }
>
> I am reading the code have more questions (and comments), but will
> send them all later.
>
> Alex.
