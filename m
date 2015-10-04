Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36071 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbJDMVy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Oct 2015 08:21:54 -0400
Received: by igcrk20 with SMTP id rk20so44416482igc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 05:21:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56111598.2080403@bouton.name>
References: <55F88ECC.1040604@menke.ac>
	<201510021421.09558.russell@coker.com.au>
	<560E737C.7050206@gmail.com>
	<201510031832.17802.russell@coker.com.au>
	<pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
	<56111598.2080403@bouton.name>
Date: Sun, 4 Oct 2015 08:21:53 -0400
Message-ID: <CAGfcS_=9uf359-uBHfEXhUC3HTpkjzE7vMwG1iOR2Ld0u3nFTg@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 4, 2015 at 8:03 AM, Lionel Bouton
<lionel-subscription@bouton.name> wrote:
>
> This focus on single reader RAID1 performance surprises me.
>
> 1/ AFAIK the kernel md RAID1 code behaves the same (last time I checked
> you need 2 processes to read from 2 devices at once) and I've never seen
> anyone arguing that the current md code is unstable.

Perhaps, but with btrfs it wouldn't be hard to get 1000 processes
reading from a raid1 in btrfs and have every single request directed
to the same disk with the other disk remaining completely idle.  I
believe the algorithm is just whether the pid is even or odd, and
doesn't take into account disk activity at all, let alone disk
performance or anything more sophisticated than that.

I'm sure md does a better job than that.

--
Rich
