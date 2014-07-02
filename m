Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36152 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaGBKua (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 06:50:30 -0400
Received: by mail-oa0-f41.google.com with SMTP id l6so12124689oag.28
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 03:50:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140702093436.GX1553@suse.cz>
References: <20140627123528.GC1553@twin.jikos.cz>
	<1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	<20140701231101.GT1553@twin.jikos.cz>
	<CALOYprWCwP0o0of0FCzrZSw8B5cU8kZT=TQB8RPJ0hXu5fF8nQ@mail.gmail.com>
	<20140702093436.GX1553@suse.cz>
Date: Wed, 2 Jul 2014 11:50:29 +0100
Message-ID: <CALOYprW2iy40SdQMkBdwyQPj5ppouuZcCoNiV00nNa_uWRcZCw@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: move the check_argc_* functions into utils.c
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 July 2014 10:34, David Sterba <dsterba@suse.cz> wrote:
>
> Oh sorry, fixed branch pushed. I've added the utils.h inlucde into
> cmds-property.c as well, fixes "implicit declaration of function"
> warnings.

Great stuff, thanks.


WorMzy
