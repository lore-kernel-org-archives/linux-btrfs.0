Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:34202 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbH1P0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 11:26:38 -0400
Received: by vkhf67 with SMTP id f67so11146216vkh.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 08:26:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DUB126-W37868A0DCD702A054C464CB46E0@phx.gbl>
References: <DUB126-W37868A0DCD702A054C464CB46E0@phx.gbl>
Date: Fri, 28 Aug 2015 09:26:37 -0600
Message-ID: <CAJCQCtQcnEQ0GJMTRi0f3fuNjux5ohRQe0qvjc+U_+QQbeSDcA@mail.gmail.com>
Subject: Re: BTRFS errors on fresh filesystem
From: Chris Murphy <lists@colorremedies.com>
To: J - <mailinglists@hotmail.nl>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 9:10 AM, J - <mailinglists@hotmail.nl> wrote:
> I have noticed a BTRFS error mentioned in two consecutive identical entries  in my kernel log:
> "BTRFS error (device sda2): bad extent! em: [0 0] passed [0 4096]"
>
> sda2 contains a btrfs with skinny extents has been created a few days ago and contains a few subvolumes (mounted as root and home) and subsubvolumes a few gigabites of data in smallish files. It is mounted with 'rw,relatime,compress-force=lzo,ssd,space_cache',

Is it reproducible without compression?

-- 
Chris Murphy
