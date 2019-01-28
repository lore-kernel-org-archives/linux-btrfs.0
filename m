Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D23C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 15:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 548052087E
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 15:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BnnzAj4v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfA1PXm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:23:42 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:39065 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfA1PXm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 10:23:42 -0500
Received: by mail-ed1-f43.google.com with SMTP id b14so13317685edt.6
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2019 07:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MmR9tL8RBtESSxlIbOo92t5TQghYnLbuECYMS8cOrbY=;
        b=BnnzAj4vcdgaAv8Kesf9RkKL8q6pJSWyXsGv9wx3REeXP+bH9yvxQ401/Jv3Sop4Tu
         klDrWX9d2F4Wu9jDVTMsq0zunVJ7EskVIx5XEPpV6lUOk3ZGn3IjZmBvUhW5v7EobSCq
         EdOuIpWsznlNi9znqFMR+bTZvUPM7F8U4AX7JJmhiIfb+NTcEHpx5tHg4PIPDEWDQN63
         HZ4TKj5Pb9INwbbuN7/PeREcP0G4olfi00E+VHtPumn3EzogzrjIC12HJCbMwoK2dxL8
         35GSBxcqzeMzfV7SPhvkBAWrQrw7WOsC8Ql5a/kM9wBQtKKnO5Bhh0WwH3eOM56LkLsu
         IbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MmR9tL8RBtESSxlIbOo92t5TQghYnLbuECYMS8cOrbY=;
        b=H/e8O+lcJO8tntI2gUe9+nf8H+hOJ/EMpRmvrZvO6bba8qRc8XrTRfguT9MOCqF9D2
         RQlC1BzryZzeWRRAu5JlAjHVb6k3DcT4exFMiIdBIEw+Nu0qPmbss/DRHBH0S9kEs7Jv
         91zqBVnitgPvQlpKgQtZ5uxPBnRX03hn/pm4qq338Zv6DLAmEN6uDuD18h3VeWTOdWjv
         yqHaoQb+EsSueA3LPuXShMVAdGhH9tuu31dsFn2uZNpAX3ufjnXfjSJxv8xmWWCSHY7n
         O9ptEQSWRSYD6VmKWBWLkyo8DBRCOgvNI/YIdHYH8lapT6EfvSsy4VlIwyAFJhLFREQL
         jARQ==
X-Gm-Message-State: AJcUukclu2eCNe8Sx3MeggBfkS6CTeCecGY1d144bTgHmwWTECCDhl//
        2kecpuzmD9Pu0pG2o8Uddnq6N01rcLKNZzKko+M=
X-Google-Smtp-Source: ALg8bN4gSKallRd6PrqJCz+q5clitOA3JWJl31NzHIVzzid0UuT9456X1c5U2UHgdQ6dL7FeXdBu8rFX0GcRf0p5KP4=
X-Received: by 2002:a50:ac81:: with SMTP id x1mr22483827edc.71.1548689020170;
 Mon, 28 Jan 2019 07:23:40 -0800 (PST)
MIME-Version: 1.0
References: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com> <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
In-Reply-To: <59a60289-1130-27b4-960b-9014fc8d68e8@gmx.com>
From:   Supercilious Dude <supercilious.dude@gmail.com>
Date:   Mon, 28 Jan 2019 15:23:28 +0000
Message-ID: <CAGmvKk7yMOUJWbzro-=+DdzgMpo71vi7+QaCWu4LYcibBAzhrg@mail.gmail.com>
Subject: Re: RAID56 Warning on "multiple serious data-loss bugs"
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     DanglingPointer <danglingpointerexception@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 28 Jan 2019 at 01:18, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> So for current upstream kernel, there should be no major problem despite
> write hole.


Can you please elaborate on the implications of the write-hole? Does
it mean that the transaction currently in-flight might be lost but the
filesystem is otherwise intact? How does it interact with data and
metadata being stored with a different profile (one with write hole
and one without)?

Thanks
