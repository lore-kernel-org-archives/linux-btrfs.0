Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36860 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbL3WNR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 17:13:17 -0500
Received: by mail-io0-f173.google.com with SMTP id o67so361422395iof.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 14:13:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
Date: Wed, 30 Dec 2015 15:13:16 -0700
Message-ID: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
From: Chris Murphy <lists@colorremedies.com>
To: "cheater00 ." <cheater00@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel and btrfs-progs versions
and output from:
'btrfs fi show <mp>'
'btrfs fi usage <mp>'
'btrfs-show-super <blockdev>'
'df -h'

Then umount the volume, and mount with option enospc_debug, and try to
reproduce the problem, then include everything from dmesg from the
time the volume was mounted.

-- 
Chris Murphy
