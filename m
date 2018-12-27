Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E117BC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 20:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 940FB21741
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 20:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mailmag.net header.i=@mailmag.net header.b="rreISVDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbeL0UdO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 15:33:14 -0500
Received: from mail.mailmag.net ([5.135.159.181]:49698 "EHLO mail.mailmag.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729867AbeL0UdO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 15:33:14 -0500
Received: from authenticated-user (mail.mailmag.net [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mailmag.net (Postfix) with ESMTPSA id 6DB68EC00D2;
        Thu, 27 Dec 2018 12:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net; s=mail;
        t=1545942791; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rC5Ebei7kGCRwevXiyjavAYIZwUJFP03Hus38pzP6WA=;
        b=rreISVDhloOhPcqGAStBzP2El8OaCNb/29lcpTewFx1rkmUO8Qg8KKHTduVkVFFNb445CN
        E0paWk62STCAmzk8p7li8HuFHZWDuskoKuYB5zHR1DcnrcPCXFmcDN6ISgtAOikc2JAHqL
        BKnQqZkuZ1drV7bFialm0inoZriOumI=
MIME-Version: 1.0
Date:   Thu, 27 Dec 2018 20:33:11 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From:   joshua@mailmag.net
Message-ID: <ffec4fbe6b91b88e1f7bd57ccb568310@mailmag.net>
Subject: Re: btrfs fi usage -T shows unallocated column as total in drive,
  not total available to btrfs
To:     "Duncan" <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
In-Reply-To: <pan$ac19$67da17d$80a83557$ce46be42@cox.net>
References: <pan$ac19$67da17d$80a83557$ce46be42@cox.net>
 <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net>
 <CAJCQCtS7XJaD4Mhrg152K4zfj-w2P0JkpUvZ0R-M6x8QmCc1tg@mail.gmail.com>
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net;
        s=mail; t=1545942791; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rC5Ebei7kGCRwevXiyjavAYIZwUJFP03Hus38pzP6WA=;
        b=SEINvn1OaH8yG5r5cGTzqJ1yeVS0m3sWVh0XofUhecoYixvtDSTTk97YLGxezAY9lPwOhF
        D/Y/sUqmKbFJpc6vcSESZqqticxglE0aPuMYp6ufRBS3G+7Ok0teBN/F4HraG7aHnnJXbQ
        HSGLy4F6guly/iUO1xc+3ifJRdSAMeo=
ARC-Seal: i=1; s=mail; d=mailmag.net; t=1545942791; a=rsa-sha256; cv=none;
        b=4IVULZpYNCX8ct3vH9l6tlcjjYq8R4Z3pkp7D27c0sfYTuK6GZsZxQDiYh3qJsmwJW8Mak
        PbxeVgLFRmX/o8TQToGWQ3bOFGKH2QxryB33lmeUn2pyLvBCVXxiMmBunWJEYmMqJCNAyV
        N5pknYwJ4rhXHcav4o/cEQS80mnrVDw=
ARC-Authentication-Results: i=1;
        mail.mailmag.net;
        auth=pass smtp.auth=joshua@mailmag.net smtp.mailfrom=joshua@mailmag.net
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

December 26, 2018 11:15 PM, "Duncan" <1i5t5.duncan@cox.net> wrote:=0A=0A>=
 Chris Murphy posted on Wed, 26 Dec 2018 17:36:19 -0700 as excerpted:=0A>=
 =0A>> I'm not really following this. An fs resize is implied by any devi=
ce=0A>> add, remove or replace command. In the case of replace, it will=
=0A>> efficiently copy the device being replaced to the designated drive,=
 and=0A>> then once that succeeds resize the file system to reflect the s=
ize of=0A>> the replacement device. I'm also confused why devid 4 seems t=
o be=0A>> present before and after your device replace, so I have to wond=
er if=0A>> your copy paste really worked out as intended? And also, what =
version of=0A>> kernel and btrfs-progs are you using?=0A> =0A> I thought.=
.. yes...=0A> =0A> Just checked the btrfs-replace manpage (v4.19.1) and i=
t says:=0A> =0A> Note=0A> the filesystem has to be resized to fully take =
advantage of a larger=0A> target device; this can be achieved with btrfs =
filesystem=0A> resize <devid>:max /path=0A> =0A> So it does *not* auto-re=
size after the replace.=0A> =0A> Also, I'm not positive on this, and I do=
n't see it mentioned in the=0A> manpage, but I /think/ replace (unlike ad=
d/remove) keeps the same devid=0A> for the new device.=0A> =0A> (And IIRC=
 one of the devs commented that there's a devid 0 during the=0A> replace =
itself, but I'm unsure whether that's the source or the=0A> destination, =
that is, whether the old ID is switched to the new device at=0A> the begi=
nning of the replace so the old one temporarily gets the 0 during=0A> the=
 replace until it's deleted at the end, or end so the new one=0A> tempora=
rily gets it until the id is transferred at the end. That was in=0A> the =
context of a draft patch that didn't yet account for the possibility=0A> =
of devid 0 during replace, and the comment was pointing out the=0A> possi=
bility.)=0A> =0A> If that's correct then the devid 4 could indeed be the =
old device at=0A> first (when it refers to sda and has 164.5 GiB unalloca=
ted), but the new=0A> device later (when it refers to sdu and has 6.53 Ti=
B unallocated), even=0A> before the resize, that being the point of confu=
sion (6.53 TB unallocated=0A> even tho it can't actually use it as it has=
n't been resized yet) that=0A> triggered the original post in the first p=
lace.=0A=0AThanks, I wasn't sure how devid's were supposed to work, but t=
hat's definitely the behavior I saw:=0Athe old device is removed (from th=
e=0A'pool'), but the new device now has the old device's devid:=0A4 /dev/=
sda 2.57TiB 3.00GiB - 164.52GiB (Before)=0A4 /dev/sdu 2.57TiB 3.00GiB - 6=
.53TiB (After)=0AAfter the device replace, I have the new device as the s=
ame devid as the old device, and pretty=0Amuch exactly the same amount of=
 space currently used. I can tell the device has changed, because it=0Ano=
w shows /dev/sdu as the device, which is the drive I replaced it with.=0A=
=0A> To address that point, I suppose ideally there'd be another line whe=
n the=0A> filesystem's smaller than the available device size, device-spa=
ce outside=0A> filesystem, or some such.=0A> =0A> Tho you are correct tha=
t fi show and fi df's output don't correspond=0A> exactly to fi usage, wi=
thout some sort of decoder ring to translate=0A> between them, and even w=
ith the decoder ring, the numbers come out but=0A> slightly different thi=
ngs are reported.=0A> =0A> Meanwhile, while I normally want the filesyste=
m usage info and thus use=0A> that command, for something like this I'd b=
e specifically interested in=0A> the specific device's usage, and thus wo=
uld use btrfs device usage, in=0A> place of or in addition to btrfs files=
ystem usage.=0A=0APerhaps my original assumptions were incorrect, but I h=
ad originally assumed that since both the=0Acommands I ran were 'btrfs fi=
' commands, that they would be reporting on the same things, just in=0Adi=
fferent formats. (btrfs fi show & btrfs fi usage)=0AI also assumed, (perh=
aps incorrectly) that since they were "filesystem" commands, (btrfs fi) t=
hey=0Awould be reporting on the amounts directly available to btrfs.=0A=
=0ARegardless, after running replace, but before running resize, 'btrfs f=
i show' reported the=0Afollowing:=0Adevid 4 size 2.73TiB used 2.57TiB pat=
h /dev/sdu=0AHowever, 'btrfs fi usage -T /mnt/data' reported the followin=
g:=0AOverall:=0ADevice size: 67.31TiB=0ADevice allocated: 41.73TiB=0ADevi=
ce unallocated: 25.58TiB=0ADevice missing: 0.00B=0AUsed: 41.69TiB=0AFree =
(estimated): 12.81TiB (min: 12.81TiB)=0AData ratio: 2.00=0AMetadata ratio=
: 2.00=0AGlobal reserve: 512.00MiB (used: 0.00B)=0A=0AData Metadata Syste=
m=0AId Path RAID1 RAID1 RAID1 Unallocated=0A-- -------- -------- --------=
 -------- -----------=0A4 /dev/sdu 2.57TiB 3.00GiB - 6.53TiB=0A{-snip-}=
=0A-- -------- -------- -------- -------- -----------=0ATotal 20.84TiB 31=
.00GiB 32.00MiB 31.95TiB=0AUsed 20.82TiB 29.60GiB 2.98MiB=0A=0AOf particu=
lar interest here is that the data in the header (Overall) is no differen=
t than before=0Athe replace, so it is fully aware the space is not (yet) =
usable, and thus reporting it correctly.=0AJust the Unallocated column is=
 potentially misleading (and the totals at the bottom)=0A=0AI should note=
 that every device in this particular Array/Pool is not using partitions;=
 I'm using=0Abtrfs directly on the device. Perhaps this is why btrfs is h=
andling it this way?  I wonder how it=0Abehaves on a partitioned FileSyst=
em.=0A=0A> It'd be interesting to see what device usage (as opposed to fi=
lesystem=0A> usage) did with the unreachable space in terms of reporting =
-- maybe it=0A> has that separate line tho I doubt it, but if not does it=
 count it or=0A> not?. But that wasn't posted and presumably the query wa=
sn't run while=0A> in the still-unresized state, and I guess it's a bit l=
ate now to get it...=0A=0AYeah, I've done the 2 replaces I have intention=
 of doing reasonably soon, so not really any chance=0Ato do that on a liv=
e filesystem at this point.=0A=0A> --=0A> Duncan - List replies preferred=
. No HTML msgs.=0A> "Every nonfree program has a lord, a master --=0A> an=
d if you use the program, he is your master." Richard Stallman
