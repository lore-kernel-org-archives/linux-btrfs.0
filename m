Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:32999 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbbHCFm0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 01:42:26 -0400
Received: by vkgc186 with SMTP id c186so38977272vkg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Aug 2015 22:42:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
Date: Sun, 2 Aug 2015 23:42:25 -0600
Message-ID: <CAJCQCtSj08YcrUTZqcO4gXb_VT5yYoxb5yy8XTUxpiwBn=mFLg@mail.gmail.com>
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can't tell what the data and metadata profile are? That it won't
mount degraded makes me think the metadata is not explicitly raid1;
and it either raid0 or accidentally single or dup which can happen at
mkfs time on single device, and just doing btrfs dev add to add
another device.

I think recovery is difficult but it depends on what sort of critical
information is in those first 32MB other than the superblock. There
are copies of the superblock so that can probably be reconstructed.


Chris Murphy
