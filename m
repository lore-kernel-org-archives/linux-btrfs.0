Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57900 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2GYRlH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:07 -0400
Received: by qcmv28 with SMTP id v28so660260qcm.11
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 10:41:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvbLMaHpxuGR=3596dwF=ttgrgUQFhcEe9qvsZOtAtf3MA@mail.gmail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-8-git-send-email-ablock84@googlemail.com>
	<CAHf9xvbKfbSQNx_Bz39-NBk2QvPZLAgWc_7+HLDpj1s45R6C6g@mail.gmail.com>
	<CAB9VWqBEXs_EE=avjqXq4708HpGWeWYJGK8esshR4fTC4+G9Gg@mail.gmail.com>
	<CAHf9xvbLMaHpxuGR=3596dwF=ttgrgUQFhcEe9qvsZOtAtf3MA@mail.gmail.com>
Date: Wed, 25 Jul 2012 19:41:06 +0200
Message-ID: <CAB9VWqCpb9R3O1qg9S-z02cYu0XMtpG8Ld=GTVuuLjWeMJ2rqA@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] Btrfs: introduce BTRFS_IOC_SEND for btrfs
 send/receive (part 2)
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2012 at 7:20 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Alexander,
>
>>> Same is true for BTRFS_FILE_EXTENT_PREALLOC extents, I think. Those
>>> also don't contain real data.
>>> So something like:
>>> if (left_disknr == 0 || left_type == BTRFS_FILE_EXTENT_REG) {
>>>         ret = 1;
>>>         goto out;
>>> }
>> Do you mean "|| left_type == BTRFS_FILE_EXTENT_PREALLOC"?
>
> I see your point about bytenr==0, I missed that on the parent tree it
> can be something else.
>
> As for PREALLOC: can it happen that on differential send we see extent
> of type BTRFS_FILE_EXTENT_PREALLOC? And can it happen that parent had
> some real data extent in that place? I don't know the answer, but if
> yes, then we must treat PREALLOC as normal extent. So this case is
> similar to bytenr==0.
>
I also don't know if that may happen. Currently, only REG extents are
checked by is_extent_unchanged. All other types are regarded as
changed and will be sent. So in the worst case the stream gets larget
then it should be, but we won't loose data. I need to leave in a few
minutes and will continue working on btrfs send/receive v2 later
today. We should probably postpone "optimizations" (actually bug
fixing) here for later...don't know if I find enough time to
investigate more.

> Thanks,
> Alex.
