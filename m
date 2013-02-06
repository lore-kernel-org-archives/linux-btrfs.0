Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60302 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3BFNDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 08:03:35 -0500
Received: by mail-ie0-f170.google.com with SMTP id c11so1896894ieb.29
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 05:03:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130205204523.GD26092@localhost.localdomain>
References: <CAK0PdAkGdGWg8TzrDK0hRgcrqqkTF7XrcOHX2wh_7DLG3G0CLA@mail.gmail.com>
 <20130205193549.GC26092@localhost.localdomain> <CAK0PdAmnZgE2+nRzrrK_FLa1xcpZPLHyUN69Kx7W5rRVV2bvTA@mail.gmail.com>
 <20130205204523.GD26092@localhost.localdomain>
From: Marguerite Su <i@marguerite.su>
Date: Wed, 6 Feb 2013 21:03:14 +0800
Message-ID: <CAK0PdAnMr20LgPriUz40YPg+uu08xqabE25Bh7W_h-Tzq+LEbA@mail.gmail.com>
Subject: Re: btrfs: Error removing orphan entry, stopping orphan cleanup.
 could not do orphan cleanup -22
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 6, 2013 at 4:45 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> Ok so I think we've fixed this already, can you build btrfs-next and try
> mounting with that and see if it fixes the problem?  Thanks,

Hi, Josef,

Is there any btrfs git compatible with kernel 3.7 and absorbs this
fix? So I can dkms it, I'm using openSUSE 12.3 Beta1 with kernel 3.7,
I can update to 3.8, but next time I do system update to RC1 it will
fallback to 3.7 again.

#btrfs-next seems to move forward to 3.8. /uapi/linux/btrfs.h doesn't
exist in kernel 3.7, it still use the old ioctl.h, I tried to revert
the ioctl.h > btrfs.h patch, but there's still errors about:

/usr/src/linux-3.7.1-1/include/trace/events/btrfs.h: In function
‘ftrace_raw_event_btrfs_transaction_commit’:
/usr/src/linux-3.7.1-1/include/trace/events/btrfs.h:61:1: error:
incompatible types when assigning to type ‘u64’ from type ‘atomic64_t’

Thanks

Marguerite
