Return-Path: <SRS0=TWZd=YP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD45CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Oct 2019 11:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A257E21872
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Oct 2019 11:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbfJVLdr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 07:33:47 -0400
Received: from rin.romanrm.net ([91.121.75.85]:44350 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbfJVLdr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Oct 2019 07:33:47 -0400
Received: from natsu (natsu.2.romanrm.net [IPv6:fd39:aa:7359:7f90:e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 2CA9C20276;
        Tue, 22 Oct 2019 11:33:44 +0000 (UTC)
Date:   Tue, 22 Oct 2019 16:33:44 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: feature request, explicit mount and unmount kernel messages
Message-ID: <20191022163344.19122329@natsu>
In-Reply-To: <CAJCQCtTPAm6eGA80y9LYc+Jaeo1wB0+vOMvO6B02o5JJKRFrhw@mail.gmail.com>
References: <CAJCQCtTPAm6eGA80y9LYc+Jaeo1wB0+vOMvO6B02o5JJKRFrhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 22 Oct 2019 11:00:07 +0200
Chris Murphy <lists@colorremedies.com> wrote:

> Hi,
> 
> So XFS has these
> 
> [49621.415203] XFS (loop0): Mounting V5 Filesystem
> [49621.444458] XFS (loop0): Ending clean mount
> ...
> [49621.444458] XFS (loop0): Ending clean mount
> [49641.459463] XFS (loop0): Unmounting Filesystem
> 
> It seems to me linguistically those last two should be reversed, but whatever.

Just a minor note, there is no "last two", but only one "Unmounting" message
on unmount: you copied the "Ending" mount-time message twice for the 2nd quote
(as shown by the timestamp).

-- 
With respect,
Roman
