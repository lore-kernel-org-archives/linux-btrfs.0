Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51593 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2GDS1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 14:27:03 -0400
Received: by obbuo13 with SMTP id uo13so11756280obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 11:27:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341409108-13567-6-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-6-git-send-email-ablock84@googlemail.com>
Date: Wed, 4 Jul 2012 21:27:02 +0300
Message-ID: <CAHf9xvaMx-nOd8BWHg_6S=FXvvGcEEp=A-BkpsMgO4cwLKgFug@mail.gmail.com>
Subject: Re: [RFC PATCH 5/7] Btrfs: add btrfs_compare_trees function
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

> +                       spin_lock(&left_root->root_times_lock);
> +                       ctransid = btrfs_root_ctransid(&left_root->root_item);
> +                       spin_unlock(&left_root->root_times_lock);
> +                       if (ctransid != left_start_ctransid)
> +                               left_start_ctransid = 0;
> +
> +                       spin_lock(&right_root->root_times_lock);
> +                       ctransid = btrfs_root_ctransid(&right_root->root_item);
> +                       spin_unlock(&right_root->root_times_lock);
> +                       if (ctransid != right_start_ctransid)
> +                               left_start_ctransid = 0;
Shouldn't it be here right_start_ctransid=0? Otherwise,
right_start_ctransid is pretty useless in this function.

> +
> +                       if (!left_start_ctransid || !right_start_ctransid) {
> +                               WARN(1, KERN_WARNING
> +                                       "btrfs: btrfs_compare_tree detected "
> +                                       "a change in one of the trees while "
> +                                       "iterating. This is probably a "
> +                                       "bug.\n");
> +                               ret = -EIO;
> +                               goto out;
> +                       }

I am reading the code have more questions (and comments), but will
send them all later.

Alex.
