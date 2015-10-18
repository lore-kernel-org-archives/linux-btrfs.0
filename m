Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33082 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbJROYk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 10:24:40 -0400
Received: by iodv82 with SMTP id v82so165209301iod.0
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 07:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56227910.7000208@gmail.com>
References: <56227910.7000208@gmail.com>
Date: Sun, 18 Oct 2015 10:24:39 -0400
Message-ID: <CAGfcS_kBeqT6bQKJNegjkcFNcEyqNF2ETg_KY64Y-7-2mc+9-g@mail.gmail.com>
Subject: Re: btrfs autodefrag?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Xavier Gnata <xavier.gnata@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 17, 2015 at 12:36 PM, Xavier Gnata <xavier.gnata@gmail.com> wrote:
> 2) Disabling copy-on-write for just the VM image directory.

Unless this has changed, doing this will also disable checksumming.  I
don't see any reason why it has to, but it does.  So, I avoid using
this at all costs.

--
Rich
