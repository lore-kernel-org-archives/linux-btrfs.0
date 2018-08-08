Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44339 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbeHHQxo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2018 12:53:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16-v6so2205961wrt.11
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Aug 2018 07:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
 <20180804131057.9967-3-lufq.fnst@cn.fujitsu.com> <20180807161912.GO3218@twin.jikos.cz>
 <20180808030437.GD3288@fnst.localdomain> <20180808135623.GU3218@twin.jikos.cz>
In-Reply-To: <20180808135623.GU3218@twin.jikos.cz>
From: Lu Fengqi <curiouslfq@gmail.com>
Date: Wed, 8 Aug 2018 22:33:35 +0800
Message-ID: <CALS+E5Dj3zg-KjEy79aBW828NcRxMYehW0poHfd0_S3rs7W1xw@mail.gmail.com>
Subject: Re: [PATCH 2/5] btrfs: use a separate variable to store the num_bytes
 of the qgroup_reserve
To: dsterba@suse.cz, lufq.fnst@cn.fujitsu.com, linux-btrfs@vger.kernel.org,
        gujx <gujx@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> 于2018年8月8日周三 下午9:57写道：
>
> On Wed, Aug 08, 2018 at 11:04:37AM +0800, Lu Fengqi wrote:
> > On Tue, Aug 07, 2018 at 06:19:12PM +0200, David Sterba wrote:
> > >On Sat, Aug 04, 2018 at 09:10:54PM +0800, Lu Fengqi wrote:
> > >> After btrfs_qgroup_reserve_meta_prealloc(), num_bytes will be assigned
> > >> again by btrfs_calc_trans_metadata_size(). Therefore, once block_rsv
> > >> fails, we cannot properly free the num_bytes of the previous
> > >> qgroup_reserve.
> > >
> > >This does not look like a trivial cleanup at all. There was an unused
> > >parameter, removed in c4c129db5da8f070147f175 ("btrfs: drop unused
> > >parameter qgroup_reserved"), that introduced the bug.  This was in this
> > >rc1 so it's a regression and I'll consider pushing it to the 4.18 final.
> >
> > I apologize for the inconvenience. I should add the Fixes tag, and really
> > shouldn't mix it into the trivial cleanup patch set.
>
> As the bug does not qualify as urgent regression, I'm not going to
> forward it to 4.18. Please update the subject and changelog so it
> reflects that's an actual fix. I'll add it to the 4.19 queue then.
> Thanks.

No problem. I will send it tomorrow.

-------------------------------------------------------------
Thanks,
Lu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
