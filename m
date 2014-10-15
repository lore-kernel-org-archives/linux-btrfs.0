Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61095 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaJOTaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 15:30:12 -0400
Received: by mail-vc0-f182.google.com with SMTP id la4so1577469vcb.27
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 12:30:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <543E8510.8020000@fb.com>
References: <543D555B.50708@pobox.com>
	<eff13bd09ee6883785a4be3ab005886b@miceliux.com>
	<543E7ACC.8080001@fb.com>
	<f9840abeffb3a13578c3358a9e6cfec0@miceliux.com>
	<543E8510.8020000@fb.com>
Date: Wed, 15 Oct 2014 15:30:11 -0400
Message-ID: <CAGfcS_moK9JLoz=nb54iNb_LCu3rtgBkYLkHLceT8eaiLJsL9g@mail.gmail.com>
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Josef Bacik <jbacik@fb.com>
Cc: Juan Orti Alcaine <juan.orti@miceliux.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 10:30 AM, Josef Bacik <jbacik@fb.com> wrote:
> We've found it, the Fedora guys are reverting the bad patch now, we'll get
> the fix sent back to stable shortly.  Sorry about that.

After reverting this commit, can the bad snapshots be
deleted/repaired/etc without wiping and restoring the entire
filesystem?  Copying 2.3TB of data isn't a particularly fast
operation...

--
Rich
