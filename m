Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:44057 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753149AbdDEHEe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Apr 2017 03:04:34 -0400
Received: from smtp10.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp10.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id EFBF062CC
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Apr 2017 03:04:33 -0400 (EDT)
Received: by smtp10.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id A0E155E4D
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Apr 2017 03:04:33 -0400 (EDT)
Subject: Re: Do different btrfs volumes compete for CPU?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
 <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
 <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru>
 <22751.32343.177176.307907@tree.ty.sabi.co.uk>
 <07258eab-5a2a-f028-48fb-60906b689cfa@rqc.ru>
 <22755.55691.456250.585931@tree.ty.sabi.co.uk>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <e4849b22-8311-f5f7-fa2e-2a56b1b78aa5@rqc.ru>
Date: Wed, 5 Apr 2017 10:04:32 +0300
MIME-Version: 1.0
In-Reply-To: <22755.55691.456250.585931@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/17 20:36, Peter Grandi wrote:
> SATA works for external use, eSATA works well, but what really
> matters is the chipset of the adapter card.
eSATA might be sound electrically, but mechanically it is awful. Try to 
run it for months in a crowded server room, and inevitably you'll get 
disconnections and data corruption. Tried different cables, brackets -- 
same result. If you ever used eSATA connector, you'd feel it.

> In my experience JMicron is not so good, Marvell a bit better,
> best is to use a recent motherboard chipset with a SATA-eSATA
> internal cable and bracket.
That's exactly what I used to use: internal controller of Z77 chipset + 
bracket(s).

> But that does not change the fact that it is a library and work
> is initiated by user requests which are not per-subvolume, but
> in effect per-volume.
That's the answer I was looking for.

> It is a way to do so and not a very good way. There is no
> obviously good way to define "real usage" in the presence of
> hard-links and reflinking, and qgroups use just one way to
> define it. A similar problem happens with processes in the
> presence of shared pages, multiple mapped shared libraries etc.
No need to over-generalize. There's an obvious good way to define "real 
usage" of a subvolume and its snapshots as long as it don't share any 
data with other subvolumes, as is often the case. If it does share, two 
figures -- exclusive and referenced, like in qgroups -- are sufficient 
for most tasks.

> The problem is that
> both hard-links and ref-linking create really significant
> ambiguities as to used space. Plus the same problem would happen
> with directories instead of subvolumes and hard-links instead of
> reflinked snapshots.
You're right, although with hard-links there's at least remote chance to 
estimate storage use with usermode scripts.

> ASMedia USB3 chipsets are fairly reliable at the least the card
> ones on the system side. The ones on the disk side I don't know
> much about.
This is getting increasingly off-topic, but our mainstay are CFI 5-disk 
DAS boxes (8253JDGG to be exact) filled with WD Red-s in RAID5 
configuration. They are no longer produced and getting harder and harder 
to source, but showed themselves as very reliable. According to lsusb 
they contain JMicron JMS567 SATA 6Gb/s bridge.

--

With Best Regards,
Marat Khalili
