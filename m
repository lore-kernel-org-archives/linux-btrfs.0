Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37561 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3AKUTa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 15:19:30 -0500
Received: by mail-ob0-f172.google.com with SMTP id za17so2153803obc.31
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 12:19:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com>
References: <CAHX0HSbVxW0HvvXi-LXPqGUDu5AZgNRJssMeWRp_MetvVc_gwQ@mail.gmail.com>
	<CAHX0HSZGuE_N1x3DTRPcQZ66B4Sqs7T9sj33=pyVs64wQSWwtw@mail.gmail.com>
Date: Fri, 11 Jan 2013 14:19:29 -0600
Message-ID: <CAKcLGm8TnSE1mcpRNt5t-u52bW2ZV_PViBHGAgM52FAy=B3jqA@mail.gmail.com>
Subject: Re: Errors not found by btrfsck or scrub
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: chris.r.carlin@gmail.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 12:13 PM, Chris Carlin <chrisrcarlin@gmail.com> wrote:
> I have a week-old filesystem that is reported clean by btrfsck and
> scrub, but that fails under operations ranging from du to sync and
> umount (but no failures if mounted readonly).
>
> My problem sounds similar to a few other reports (e.g. TM's in
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/22014 ) that
> seem to hint at problems with full metadata. My df shows:
>

I know this advice will run counter to what everyone else is saying,
but I've had some luck booting with an older kernel (such as 3.4 or
3.5) just long enough to get some more Metadata allocated.

I would also caution you to back up your data.  I've had a similar
issue, and that file system soon showed additional corruptions.
