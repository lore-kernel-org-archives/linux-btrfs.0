Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49323 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbcABVmC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 16:42:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 608EB2011E
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 16:42:02 -0500 (EST)
Message-Id: <1451770922.3033840.481239506.104E7642@webmail.messagingengine.com>
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Add big device, remove small device, read-only
Date: Sat, 02 Jan 2016 22:42:02 +0100
In-Reply-To: <CAJCQCtTvXTO=-N9r+o2BD=UCd0ULAxa_BnF16Bw7W5Xy4aEWag@mail.gmail.com>
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
 <CAJCQCtTvXTO=-N9r+o2BD=UCd0ULAxa_BnF16Bw7W5Xy4aEWag@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do you mean that the pipe is not a bash pipe or that you executed the
commands as written? Sounds like you had two terminals and executed the
left side of the pipe and then the right side.

On Sat, Jan 2, 2016, at 10:37 PM, Chris Murphy wrote:
> On Sat, Jan 2, 2016 at 2:30 PM, Rasmus Abrahamsen <btrfs@rasmusa.net>
> wrote:
> > Okay, I will rebuild it then. Thank you.
> >
> > Where do I add -p?
> 
> OK for me, I have these ro snapshots:
> drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150403
> drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150404
> drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150412
> drwxrwx---. 1 chris chris  218 Apr  3  2015 everything-20150922
> 
> # btrfs send everything-20150403 | btrfs receive /mnt/new
> # btrfs send -p everything-20150403 everything-20150404 | btrfs receive
> /mnt/new
> # btrfs send -p everything-20150404 everything-20150412 | btrfs receive
> /mnt/new
> # btrfs send -p everything-20150412 everything-20150922 | btrfs receive
> /mnt/new
> 
> I have not tried to use && in between those, instead of just
> separately issuing the commands.
> 
> It's valid to always use the same first subvolume as -p, but the
> increments are then larger so even though it succeeds, it's also
> inefficient.
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
