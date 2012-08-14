Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63472 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2HNOJk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 10:09:40 -0400
Received: by ghrr11 with SMTP id r11so468949ghr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 07:09:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1y0sdEePQbRUwvmbCqGMxfPqwCiUKxWcuxczFFEhtait1sNQ@mail.gmail.com>
References: <5027DDFC.60504@pocock.com.au>
	<CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
	<502A529B.8060201@pocock.com.au>
	<CAG1y0sdEePQbRUwvmbCqGMxfPqwCiUKxWcuxczFFEhtait1sNQ@mail.gmail.com>
Date: Tue, 14 Aug 2012 08:09:39 -0600
Message-ID: <CAE5mzvj_xX6dZVSd3joi9Pgn-yxiRA3Aa+Aqam3gj-VCbQ6C=Q@mail.gmail.com>
Subject: Re: raw partition or LV for btrfs?
From: cwillu <cwillu@cwillu.com>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: Daniel Pocock <daniel@pocock.com.au>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> If I understand correctly, if I don't use LVM, then such move and resize
>> operations can't be done for an online filesystem and it has more risk.
>
> You can resize, add, and remove devices from btrfs online without the
> need for LVM. IIRC LVM has finer granularity though, you can do
> something like "move only the first 10GB now, I'll move the rest
> later".

You can certainly resize the filesystem itself, but without lvm I
don't believe you can resize the underlying partition online.
