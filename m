Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48578 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2E2XL1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 19:11:27 -0400
Received: by yhmm54 with SMTP id m54so2805411yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:11:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC55043.4050004@gmail.com>
References: <4FC54A5D.8000600@gmail.com>
	<4FC55043.4050004@gmail.com>
Date: Tue, 29 May 2012 17:11:26 -0600
Message-ID: <CAE5mzvg_gLxkYhE1h7aunvvYHgsKjpo2xfLqv4A++S=UAOiySw@mail.gmail.com>
Subject: Re: Help with data recovering
From: cwillu <cwillu@cwillu.com>
To: Maxim Mikheev <mikhmv@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can't help much at the moment, but the following will help sort things out:

Can you provide as much detail as possible about how things were
configured at the time of the failure?  Raid levels used, kernel
versions at the time of the failure, how the disks are connected,
general description of the activity on the disk and the nature of its
contents (all large files? rootfs? mail spools?)  What you were
thinking at the time you decided that you couldn't afford backups? As
much detail as possible on what all you've tried since the failure to
recover things?

It's likely the data is fine (if currently inaccessible), but
obviously things are in a fragile state, and the important thing right
now is to not make things worse: a recoverable situation may otherwise
turn into an irrecoverable one.
