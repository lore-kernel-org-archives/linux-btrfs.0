Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44605 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2GCMJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 08:09:15 -0400
Received: by pbbrp8 with SMTP id rp8so9152055pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2012 05:09:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF2DFD6.2020504@cn.fujitsu.com>
References: <1340963995-32549-1-git-send-email-liubo2009@cn.fujitsu.com>
	<1340963995-32549-2-git-send-email-liubo2009@cn.fujitsu.com>
	<CAB9VWqBnEETwZmdLV7S=m=mikpmw5JUw677aCaGFioUHkSGcsw@mail.gmail.com>
	<4FF2DFD6.2020504@cn.fujitsu.com>
Date: Tue, 3 Jul 2012 14:09:15 +0200
Message-ID: <CAB9VWqBOnYN8c85LDUZ-z0UdW4+Q2MfCS9aetvJwnYhjUYxCnA@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs: update subvol_getflags/setflags to know new
 args from user
From: Alexander Block <ablock84@googlemail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 3, 2012 at 2:04 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
>>>
>>> +struct btrfs_ioctl_get_set_flags_args {
>>> +       __u64 objectid;
>>> +       __u64 flags;
>>> +};
>>> +
>> Shouldn't BTRFS_IOC_SUBVOL_GETFLAGS/BTRFS_IOC_SUBVOL_SETFLAGS also be
>> updated? Both still have __u64 as arguments. Also, my patches for the
>> new btrfs prop command group won't work anymore due to the change in
>> the ioctl. I'm in the middle of preparing btrfs send/receive to be
>> sent to the list...I also use the ioctls there and we should agree on
>> what to do with the ioctls before I send the patches out.
>
>
> Just drop this patch, I've discussed with Ilya about it (and also CCed you).
>
> If we've more properties pending to set/get, 'btrfs property' will be better.
>
> So please go on your work, I'll try to rebase my patch on yours.
Ah sorry, I've somehow missed that. Thanks for the clarification :)
>
> thanks,
> liubo
>
