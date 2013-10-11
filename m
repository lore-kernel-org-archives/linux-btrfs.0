Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62455 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3JKJjI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 05:39:08 -0400
Received: by mail-wi0-f175.google.com with SMTP id ez12so812424wid.8
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 02:39:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5257C4C8.2010205@yerf-it.nl>
References: <1381426821-31981-1-git-send-email-idryomov@gmail.com>
	<525750B4.4090009@cn.fujitsu.com>
	<5257C378.1060507@giantdisaster.de>
	<5257C4C8.2010205@yerf-it.nl>
Date: Fri, 11 Oct 2013 12:39:07 +0300
Message-ID: <CAOi1vP_VP7fVxcc8eoij1aZ=v5ADqBByq3cmBZCLbRO9tq034A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: disallow 'btrfs {balance,replace} cancel' on ro mounts
From: Ilya Dryomov <idryomov@gmail.com>
To: Remco Hosman - Yerf-IT <remco@yerf-it.nl>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 11, 2013 at 12:28 PM, Remco Hosman - Yerf-IT
<remco@yerf-it.nl> wrote:
> i would expect a RO mount never to write anything to a filesystem. not even
> replay a journal (or a seperate option for that).
> Its possible that the device is not writable at all, if its a snapshot or a
> RO iscsi device of some kind.

I agree, and that's exactly the point of this patch.

Thanks,

                Ilya
