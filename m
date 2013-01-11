Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:40439 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3AKW3X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 17:29:23 -0500
Received: by mail-vb0-f53.google.com with SMTP id b23so1941554vbz.12
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 14:29:22 -0800 (PST)
MIME-Version: 1.0
Reply-To: chris.r.carlin@gmail.com
In-Reply-To: <50F06639.6030409@home.nl>
References: <50F06639.6030409@home.nl>
From: Chris Carlin <chrisrcarlin@gmail.com>
Date: Fri, 11 Jan 2013 17:29:02 -0500
Message-ID: <CAHX0HSZoCpuOiOdNmLpU8LBtTXv=A1ddNdovtrUTGcP_wgvPHA@mail.gmail.com>
Subject: Re: partition question
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 2:21 PM, Roelof Wobben <r.wobben@home.nl> wrote:
> Hello,
>
> I have one thing I think I don't really understand about btrfs,
>
> Normally if I use ext4 I make a  3 partitions for my distro.
>
> one for boot about 1G
> one for home about 30G
> one for root for the rest of my 100G.
>
> Now I wonder if I want to do the same with btrfs.
>
> Can I do the same so make 3 partitions with btrfs or can I better make 1
> partiton of 100G and make the /boot /home and  / subvolumes of the big
> partitiion.

Well. what is your motivation for doing it that way in the ext4?

If you're looking to be able to selectively mount sections of your
filesystem, then sure, subvolumes might work, but a lot of people
divide partitions this way so that they'd be independent for purposes
of reliability. Subvolumes of one btrfs partition wouldn't provide
that independence.

~Chris
