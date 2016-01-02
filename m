Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36907 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbcABVax (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 16:30:53 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 62E4120146
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Jan 2016 16:30:53 -0500 (EST)
Message-Id: <1451770253.3032043.481236290.26B8D142@webmail.messagingengine.com>
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Add big device, remove small device, read-only
Date: Sat, 02 Jan 2016 22:30:53 +0100
In-Reply-To: <CAJCQCtQa6WD5TGQ2gUOTPdtEXBVhYQqsHG_fmuKTkkfQDnLNmQ@mail.gmail.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
 <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
 <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
 <CAJCQCtTn1xZ3KLQoPqjDowu__f5AAAXHNye2vU4ceEb6VFK--w@mail.gmail.com>
 <1451764729.3016753.481194250.0BE48A69@webmail.messagingengine.com>
 <CAJCQCtSJp-p06VCrSaoeqAOFtnt=EfCMKfRF-DVkjpAiW9iv3A@mail.gmail.com>
 <CAJCQCtQLrh5AM2eRp0g0UvAOedz3=Y8qm1XAi7PV7m26uZsR-Q@mail.gmail.com>
 <1451767152.3023000.481211490.1B8EC687@webmail.messagingengine.com>
 <CAJCQCtQa6WD5TGQ2gUOTPdtEXBVhYQqsHG_fmuKTkkfQDnLNmQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, I will rebuild it then. Thank you.

Where do I add -p?

On Sat, Jan 2, 2016, at 10:28 PM, Chris Murphy wrote:
> On Sat, Jan 2, 2016 at 1:39 PM, Rasmus Abrahamsen <btrfs@rasmusa.net>
> wrote:
> > Sounds like you think my best bet is to re-roll my filesystem instead of
> > attempt to repair it. Is that right?
> 
> If you want to get back to a working fs as soon as possible, yes. You
> could take a btrfs-image of it first; if that fails you can use
> btrfs-debug-tree. Both of those should direct the output to a file on
> another file system. Maybe a dev will find it useful?
> 
> And then if you want you can keep trying to repair it, but my
> experience is that in such cases the fs quickly is in the weeds and is
> beyond repair even when it's possible to ro mount or use restore to
> get all data out.
> 
> 
> > I have snapshots which are based on each other as a backup of a remote
> > machine by date. By sending these snapshots to a new filesystem, will I
> > be able to have them still be incremental and save space?
> 
> Yes, the first one without -p is the big send. Then each additional
> one uses the most immediate previous snapshot with -p. I haven't tried
> the -e option with multiple increments, so I don't know if that works
> or if it's expected to work.
> 
> I'm having to do this right now myself with an imploded raid1 that
> won't mount so I might find out in the next hour or two if -e works.
> 
> 
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
