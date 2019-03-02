Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B7AC43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 02:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE3F20815
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 02:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Fp3XUcDD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfCBC3a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 21:29:30 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42839 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfCBC33 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2019 21:29:29 -0500
Received: by mail-lf1-f67.google.com with SMTP id p1so19374277lfk.9
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 18:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FS8+3VgENQUhdEHBaEUj3s8VTRI9ZWu5ESJv2CYzdns=;
        b=Fp3XUcDDCmnLqXo83KQDLfSOPLw55TPsGzOpMGVsApwmVsTHzzmvpKWvTQx9ILauoL
         n20JqajS8AVv2SSPcXufpG7EyPbp6eW+ceqyI5Se0H2UmGLZGQeaL/v2RmCqadAX5gdE
         VC/WtddLwrq8lSyaCJaeB0LlTG7vxLhilbyPcveBE2S79EtCHQQN/RlIqALCUjbj3Lwx
         uNAF0PZN8iHUlNQ8aEJi6n4oNColL0hQMvMuD4v8AIciZkyf8NALFJUxeUMt3BHjZiQe
         o7LpNHnRySLhmAiXEXa4Z7BkA5SlYe6OAGnFNXDPAz6xS0l8K/0qsIth51Obj2TvsIIE
         z4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FS8+3VgENQUhdEHBaEUj3s8VTRI9ZWu5ESJv2CYzdns=;
        b=ElWdiV/T1J0zZ8cWmj1mJ8v/fkiF2OJAv6SOaareFdO/bVoyBXB4GRO7DBRvCjWzVK
         6S/9RO9T9kcGrV8Tuuguw9BktM3qzENB/bjg488DKWxm48z9ysmQsjyeSLDT55n88OF5
         dbR+z7tE/l22JJCOgepkX4bHzENfctQw6YwW7VPTPK2O1ZVE+bfnMWvPe6s3SgSQSiOS
         B/bnrNvI7MMpC1iJUZ/LOB9xq9/evqbqXG5lXkjK3Jo/3xdruswzdMnmWF2r4ennxqOY
         siuLn48A4khdEXEZoCDOcWhHYFgtfdOZzPwbFjjQImQjIw6kreuBC++YcoXifQ1czvOt
         sTFQ==
X-Gm-Message-State: APjAAAX89tgOJ62jEPBjtYTgdD4G1Urip96PO3JE7djOSpg2eRC3ulW4
        2dMrIe2Xo5Tzo5HqzGgg/VflMbhDZ44eg77zRO2Eig==
X-Google-Smtp-Source: APXvYqxon3SohSfwoH8kti+CgpdMrIFHqc2JdIB5VtvOOST3eaVcRXjw3QOJom/CNBKz5NhCdQAT95fK0UUTpGbYdk8=
X-Received: by 2002:a19:6e0b:: with SMTP id j11mr4492685lfc.124.1551493768007;
 Fri, 01 Mar 2019 18:29:28 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
 <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com>
In-Reply-To: <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 1 Mar 2019 19:29:16 -0700
Message-ID: <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 1, 2019 at 6:05 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/3/2 =E4=B8=8A=E5=8D=888:20, Chris Murphy wrote:
> > Problem happens with btrfsprogs 4.19.1
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D202717
> >
> > That bug report includes the trace in user space; but I've also
> > processed the resulting coredump file with gdb and attached that to
> > the bug report.
> >
> > Before using --clear-space-cache v1, btrfs scrub and btrfs check came
> > up clean no errors. Following the crash, I compiled brfsprogs 4.20.2
> > and ran 'btrfs check' which finds corruption.
> >
> > I've taken no further action, and the btrfs check output gives me no
> > useful plain language information what the next steps are. So I'm just
> > gonna leave it alone since it's a backup volume anyway.
>
> Is the backup volume binary dump of the original fs?

No. Only btrfs send/receive.


>
> I'm interesting why clear space cache v1 doesn't work, to find out that,
> we need tree dump of the original fs.

btrfs insp dump-t -t 2 ? Or the whole thing?

>
> And is the original check done by latest btrfs-progs or v4.19.1?

The original check is 4.19.1
The clear cache is 4.19.1
The subsequent check showing corruption is 4.20.2 but I've found that
it's the same output for 4.19.1 as well.


--=20
Chris Murphy
