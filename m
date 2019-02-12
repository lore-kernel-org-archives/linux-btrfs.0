Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF9BC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ADB52084E
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549994394;
	bh=UV02dLCAOMRppntZZdZX3NBABT2AcBO6PNVdWOAbeOE=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=STNuyAiUnjG6rmcmwDIwJ7QMO43vfUyKQ4giecsguB+xbyH/q5r5+YU/g54HiRCyq
	 pt/m/DCWCw5FC2shTss3dr1bmKpiaBxirnsYb62fAbW6SssedKTsMUHeqBxMIVUnWI
	 /DDsP4Pz6ZAUxeg+C2CSK8M7makOGZw7VmXSJUkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfBLR7x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfBLR7x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 12:59:53 -0500
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E81222C5
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 17:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549994392;
        bh=UV02dLCAOMRppntZZdZX3NBABT2AcBO6PNVdWOAbeOE=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=CLDLgjHswrPmsSkD5kilPFPWsAKsR4oZbYnxNiviI5Z3gYfjqasDOAtkSmosw99+u
         jGAXJL4p1+tUorkM+bHZqOu+CxoPne7NGm56hxuRubUlpZhqYpUh7fJiql2eC3hqy2
         MqkOEyGyu+K/YXGOSbI2OoxxHjvfLxZKlhvrz2Jc=
Received: by mail-vk1-f172.google.com with SMTP id d201so836264vka.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 09:59:52 -0800 (PST)
X-Gm-Message-State: AHQUAuY2g5D7S2pGOD9/cI832j+niBZDBGP1mOWKFais0ccYiU3u5O/U
        eAgPY63d+hvGRcOlXydsmdr1lD9YG+cIkI6Vp18=
X-Google-Smtp-Source: AHgI3IYxiEA7La2FrWcjf09DIO6OWuKgR+ZeMOZ8JLHf/+RCdsv1EcshhdskmfnVr+0WIhNONock00RPgNIBKSyYbQM=
X-Received: by 2002:a1f:d5c4:: with SMTP id m187mr1962930vkg.23.1549994391780;
 Tue, 12 Feb 2019 09:59:51 -0800 (PST)
MIME-Version: 1.0
References: <20181212180559.15249-1-fdmanana@kernel.org> <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz> <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
In-Reply-To: <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 12 Feb 2019 17:59:41 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7eNikSyf78cP+DpRAoYS0nRXNVZn6EvxXRBbYxSMasVw@mail.gmail.com>
Message-ID: <CAL3q7H7eNikSyf78cP+DpRAoYS0nRXNVZn6EvxXRBbYxSMasVw@mail.gmail.com>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for deduplication
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 4:39 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Checking if the destination root is read-only was being performed only for
> > > clone operations. Make deduplication check it as well, as it does not make
> > > sense to not do it, even if it is an operation that does not change the
> > > file contents (such as defrag for example, which checks first if the root
> > > is read-only).
> >
> > And this is also change in user-visible behaviour of dedupe, so this
> > needs to be verified if it's not breaking existing tools.
>
> Have you had the chance to do such verification?
>
> This actually conflicts with send. Send does not expect a root/tree to
> change, and with dedupe on read-only roots happening
> in parallel with send is going to cause all sorts of unexpected and
> undesired problems...
>
> This is a problem introduced by dedupe ioctl when it landed, since
> send existed for a longer time (when nothing else was
> allowed to change read-only roots, including defrag).

Another ping.
This is a problem that has to be solved one way or another.

Thanks.

>
> I understand it can break some applications, but adding other solution
> such as preventing send and dedupe from running in parallel
> (erroring out or block and wait for each other, etc) is going to be
> really ugly. There's always the workaround for apps to set the
> subvolume
> to RW mode, do the dedupe, then switch it back to RO mode.
>
> Thanks.
