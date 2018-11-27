Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC4EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1628820873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEPOqNRm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1628820873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbeK1Gmu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:42:50 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46894 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbeK1Gmu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:42:50 -0500
Received: by mail-ua1-f66.google.com with SMTP id v24so8026055uap.13
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 11:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=UwXHKQSjOnwWkDA01PqioDlwGOo13JMcfPOjeyzb/hc=;
        b=hEPOqNRmC2eSW1lWpZ612RjXV2NejHi2ImutsG9jquX8F8VeaTqgNh42HWRpSQlt5g
         dzunACkpO77/Tc069JIIyE43Hx0BHTsuP36lEdv7TA2oYPYi6pQkSSCZFgwDR1lqharW
         zBpgBt9Mlg4YMwmDwbn17TY8/o+rhghE/g8CwkkM71cK35AwReZcFyd1dJjv1a1veC9x
         bL5+vMWKweOH8kBNQ9XJn8AGwIE6+2L9C/71mBSID6Oj3m0VkVBKm6zcSgQ5mOJBbYbT
         pSeH/pzdacu0uYMP8Kh2dme7qXDRK3BITRxvu5H+IVCXb5h06h4g4IGWfT44y5Zk9Vs0
         p4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=UwXHKQSjOnwWkDA01PqioDlwGOo13JMcfPOjeyzb/hc=;
        b=suIVmbYMMmx6zrh0ZTt0ctgn/k4nNiY146zq7glUhtbIfppR/Ngrb4ZwNcb281uYJu
         k+S9jv1stEU71gGAtx+Honi11lRf7OV8dUcNYBYcaEnzWP7KcBg5gp1CaBGCY2VxKQlS
         u9aern9GrKwEEsCwyH7GVdADBlqXy/AD2Yz4eZQ6DyETvJAy6+XymqRN/c2ELas8M+jf
         FQaNQSmxHGdE1F8lrxUPhAgNY7udZHLpoGJfx7HyCcaDHrBrOXEoaoiiYWaHFXKViWfu
         FYjFk7ntVUHN1BTfqzOR3vYXgippGmySTA8Fz+jN0CCziktYsPYckLVbLdxwHD/ZXtUY
         sGmQ==
X-Gm-Message-State: AA+aEWYwlRojeWEsyf7kOE2Fek8fDPYcSyBHSx1m/TtZnNxVTU1Yg5VY
        HWdahvW0h1Jq48dtPpQAGlZqE9Jnd2k9pD/5XPI=
X-Google-Smtp-Source: AFSGD/VL2n4arQMTodK/fK4FHS6S0mZ4qUzlEOGF6YpuWL0p0OUOHtxx/FgractKdDo32Oy9d0ZiNH0fZuJDnrZCoCg=
X-Received: by 2002:ab0:590a:: with SMTP id n10mr14175470uad.137.1543347831189;
 Tue, 27 Nov 2018 11:43:51 -0800 (PST)
MIME-Version: 1.0
References: <20181121191016.25224-1-josef@toxicpanda.com> <CAL3q7H45FX3VO0h_9u5-M38ObiWaZPgyXezUDT-4rJvx7BUkhw@mail.gmail.com>
 <20181127192224.zozqhtpcuv5j2qcm@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20181127192224.zozqhtpcuv5j2qcm@macbook-pro-91.dhcp.thefacebook.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 27 Nov 2018 19:43:39 +0000
Message-ID: <CAL3q7H4esyeG6uUvegUHdGy0k4Szv8-iw5dDAzUpwiBS_hd7hg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: only run delayed refs if we're committing
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 7:22 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> On Fri, Nov 23, 2018 at 04:59:32PM +0000, Filipe Manana wrote:
> > On Thu, Nov 22, 2018 at 12:35 AM Josef Bacik <josef@toxicpanda.com> wro=
te:
> > >
> > > I noticed in a giant dbench run that we spent a lot of time on lock
> > > contention while running transaction commit.  This is because dbench
> > > results in a lot of fsync()'s that do a btrfs_transaction_commit(), a=
nd
> > > they all run the delayed refs first thing, so they all contend with
> > > each other.  This leads to seconds of 0 throughput.  Change this to o=
nly
> > > run the delayed refs if we're the ones committing the transaction.  T=
his
> > > makes the latency go away and we get no more lock contention.
> >
> > Can you share the following in the changelog please?
> >
> > 1) How did you ran dbench (parameters, config).
> >
> > 2) What results did you get before and after this change. So that we al=
l get
> >     an idea of how good the impact is.
> >
> > While the reduced contention makes all sense and seems valid, I'm not
> > sure this is always a win.
> > It certainly is when multiple tasks are calling
> > btrfs_commit_transaction() simultaneously, but,
> > what about when only one does it?
> >
> > By running all delayed references inside the critical section of the
> > transaction commit
> > (state =3D=3D TRANS_STATE_COMMIT_START), instead of running most of the=
m
> > outside/before,
> > we will be blocking for a longer a time other tasks calling
> > btrfs_start_transaction() (which is used
> > a lot - creating files, unlinking files, adding links, etc, and even fs=
ync).
> >
> > Won't there by any other types of workload and tests other then dbench
> > that can get increased
> > latency and/or smaller throughput?
> >
> > I find that sort of information useful to have in the changelog. If
> > you verified that or you think
> > it's irrelevant to measure/consider, it would be great to have it
> > mentioned in the changelog
> > (and explained).
> >
>
> Yeah I thought about the delayed refs being run in the critical section n=
ow,
> that's not awesome.  I'll drop this for now, I think just having a mutex =
around
> running delayed refs will be good enough, since we want people who care a=
bout
> flushing delayed refs to wait around for that to finish happening.  Thank=
s,

Well, I think we can have a solution that doesn't bring such trade-off
nor introducing a mutex.
We could do like what is currently done for writing space caches, to
make sure only the first task
calling commit transaction does the work and all others do nothing
except waiting for the commit to finish:

btrfs_commit_transaction()
   if (!test_and_set_bit(BTRFS_TRANS_COMMIT_START, &cur_trans->flags)) {
       run delayed refs before entering critical section
   }

thanks

>
> Josef



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
