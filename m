Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36634 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbcABVhs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 16:37:48 -0500
Received: by mail-io0-f176.google.com with SMTP id o67so407563298iof.3
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jan 2016 13:37:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451770253.3032043.481236290.26B8D142@webmail.messagingengine.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
	<CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
	<1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
	<CAJCQCtTn1xZ3KLQoPqjDowu__f5AAAXHNye2vU4ceEb6VFK--w@mail.gmail.com>
	<1451764729.3016753.481194250.0BE48A69@webmail.messagingengine.com>
	<CAJCQCtSJp-p06VCrSaoeqAOFtnt=EfCMKfRF-DVkjpAiW9iv3A@mail.gmail.com>
	<CAJCQCtQLrh5AM2eRp0g0UvAOedz3=Y8qm1XAi7PV7m26uZsR-Q@mail.gmail.com>
	<1451767152.3023000.481211490.1B8EC687@webmail.messagingengine.com>
	<CAJCQCtQa6WD5TGQ2gUOTPdtEXBVhYQqsHG_fmuKTkkfQDnLNmQ@mail.gmail.com>
	<1451770253.3032043.481236290.26B8D142@webmail.messagingengine.com>
Date: Sat, 2 Jan 2016 14:37:47 -0700
Message-ID: <CAJCQCtTvXTO=-N9r+o2BD=UCd0ULAxa_BnF16Bw7W5Xy4aEWag@mail.gmail.com>
Subject: Re: Add big device, remove small device, read-only
From: Chris Murphy <lists@colorremedies.com>
To: Rasmus Abrahamsen <btrfs@rasmusa.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 2, 2016 at 2:30 PM, Rasmus Abrahamsen <btrfs@rasmusa.net> wrote:
> Okay, I will rebuild it then. Thank you.
>
> Where do I add -p?

OK for me, I have these ro snapshots:
drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150403
drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150404
drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150412
drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150922

# btrfs send everything-20150403 | btrfs receive /mnt/new
# btrfs send -p everything-20150403 everything-20150404 | btrfs receive /mnt/new
# btrfs send -p everything-20150404 everything-20150412 | btrfs receive /mnt/new
# btrfs send -p everything-20150412 everything-20150922 | btrfs receive /mnt/new

I have not tried to use && in between those, instead of just
separately issuing the commands.

It's valid to always use the same first subvolume as -p, but the
increments are then larger so even though it succeeds, it's also
inefficient.

-- 
Chris Murphy
