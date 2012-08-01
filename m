Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59358 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2HAFNc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 01:13:32 -0400
Received: by yhmm54 with SMTP id m54so6922540yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 22:13:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120801010104.GA7089@merlins.org>
References: <20120731180412.GA10520@merlins.org>
	<20120801010104.GA7089@merlins.org>
Date: Tue, 31 Jul 2012 23:13:31 -0600
Message-ID: <CAE5mzvgedV-XOWy4CgG5H9Eo9ONJXiHp2HgysCCmZjctaQUDqA@mail.gmail.com>
Subject: Re: BTRFS crash on mount with 3.4.4
From: cwillu <cwillu@cwillu.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [  186.277795] Btrfs detected SSD devices, enabling SSD mode
> [  188.477443] btrfs: unlinked 6 orphans
> [  188.477451] btrfs: truncated 1 orphans
> [  411.837015] btrfs: unlinked 13 orphans
> [  414.373500] btrfs: unlinked 35 orphans
>
> This seems to hint that I lost random files and that I don't know what they are.
>
> I suppose I can go back to my latest hourly snapshot which is more likely to not have
> truncated or missing files.

I believe it just means "the space for stuff that was
deleted/unlinked/truncated, but which didn't get reclaimed before the
crash".
