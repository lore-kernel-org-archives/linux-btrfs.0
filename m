Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAFDC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 14:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D76FF223DD
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 14:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UB/DPtxL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D76FF223DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387713AbeKNAmy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 19:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbeKNAmy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 19:42:54 -0500
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D16FE223DD
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 14:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542120267;
        bh=+6gY57qb9UNiwj7r2DtR2e9h4ldsfUpAEiZC9ivl4fk=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=UB/DPtxLb5XOZ1RWz9Bf6ZEqFOH3E7rGBuBk15jhM8UNUIT/mJzGpuEZRFivY+TjK
         umAc0PkfJRc1HkSc4LemHrQci4ETuYIezDf1omY90qxVuO0styovdfu8XSqnJCoWcR
         vqZWrWtyLoDWP+KUSja+pKLTp6SMSZl+DHz0WVlY=
Received: by mail-vs1-f46.google.com with SMTP id r14so7368538vsc.13
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 06:44:26 -0800 (PST)
X-Gm-Message-State: AGRZ1gKOnlAuHaIAotArfl5/2AWMT72thEq5qG5kFjMpdmg6cPkO4eNt
        0M8VwCLrXuNPI49gActSDaqdbLVETDtVG7qfuxs=
X-Google-Smtp-Source: AJdET5f0kpHmMDIH5gieOU3ZIil+TMd4xbmSUNkAAhBl35Ht7tBF0qayX5Yd7CV1yurzlOz8Z9tmyIWl3/CX1gAWj+4=
X-Received: by 2002:a67:8a81:: with SMTP id m123mr2465002vsd.206.1542120265806;
 Tue, 13 Nov 2018 06:44:25 -0800 (PST)
MIME-Version: 1.0
References: <20181108131750.27833-1-fdmanana@kernel.org> <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
 <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com> <20181113143121.GZ24115@twin.jikos.cz>
In-Reply-To: <20181113143121.GZ24115@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 13 Nov 2018 14:44:14 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6dAGY48aKPZumd2OfKg7=FgWQgKka-zZUcZs2v7syKRw@mail.gmail.com>
Message-ID: <CAL3q7H6dAGY48aKPZumd2OfKg7=FgWQgKka-zZUcZs2v7syKRw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
To:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 13, 2018 at 2:31 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Thu, Nov 08, 2018 at 02:48:29PM +0000, Filipe Manana wrote:
> > On Thu, Nov 8, 2018 at 2:37 PM Filipe Manana <fdmanana@kernel.org> wrot=
e:
> > >
> > > On Thu, Nov 8, 2018 at 2:35 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
> > > >
> > > >
> > > >
> > > > On 2018/11/8 =E4=B8=8B=E5=8D=889:17, fdmanana@kernel.org wrote:
> > > > > From: Filipe Manana <fdmanana@suse.com>
> > > > >
> > > > > When creating a block group we don't need to set the log for full=
 commit
> > > > > if the new block group is not used for data. Logged items can onl=
y point
> > > > > to logical addresses of data block groups (through file extent it=
ems) so
> > > > > there is no need to for the next fsync to fallback to a transacti=
on commit
> > > > > if the new block group is for metadata.
> > > >
> > > > Is it possible for the log tree blocks to be allocated in that new =
block
> > > > group?
> > >
> > > Yes.
> >
> > Now I realize what might be your concern, and this would cause trouble.
>
> Is this patch ok for for-next or does it need more work? Thanks.

Nop, it's no good (despite not triggering problems initially), due to
Qu's first question.
So just drop it and forget it.
Thanks.
