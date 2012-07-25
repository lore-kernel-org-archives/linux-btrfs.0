Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60488 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2GYRUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 13:20:32 -0400
Received: by yhmm54 with SMTP id m54so963765yhm.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 10:20:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqBEXs_EE=avjqXq4708HpGWeWYJGK8esshR4fTC4+G9Gg@mail.gmail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-8-git-send-email-ablock84@googlemail.com>
	<CAHf9xvbKfbSQNx_Bz39-NBk2QvPZLAgWc_7+HLDpj1s45R6C6g@mail.gmail.com>
	<CAB9VWqBEXs_EE=avjqXq4708HpGWeWYJGK8esshR4fTC4+G9Gg@mail.gmail.com>
Date: Wed, 25 Jul 2012 20:20:32 +0300
Message-ID: <CAHf9xvbLMaHpxuGR=3596dwF=ttgrgUQFhcEe9qvsZOtAtf3MA@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] Btrfs: introduce BTRFS_IOC_SEND for btrfs
 send/receive (part 2)
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander,

>> Same is true for BTRFS_FILE_EXTENT_PREALLOC extents, I think. Those
>> also don't contain real data.
>> So something like:
>> if (left_disknr == 0 || left_type == BTRFS_FILE_EXTENT_REG) {
>>         ret = 1;
>>         goto out;
>> }
> Do you mean "|| left_type == BTRFS_FILE_EXTENT_PREALLOC"?

I see your point about bytenr==0, I missed that on the parent tree it
can be something else.

As for PREALLOC: can it happen that on differential send we see extent
of type BTRFS_FILE_EXTENT_PREALLOC? And can it happen that parent had
some real data extent in that place? I don't know the answer, but if
yes, then we must treat PREALLOC as normal extent. So this case is
similar to bytenr==0.

Thanks,
Alex.
