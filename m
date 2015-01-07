Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:63081 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbbAGELJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jan 2015 23:11:09 -0500
Received: by mail-la0-f48.google.com with SMTP id gf13so1301535lab.7
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jan 2015 20:11:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54AA7CAD.7060201@gmail.com>
References: <CALJXSJqF-7KfDJS27ZdYpQWZcr8XOHoFA1LjKJFfXJA2Unnz1w@mail.gmail.com>
	<54AA7CAD.7060201@gmail.com>
Date: Tue, 6 Jan 2015 23:11:08 -0500
Message-ID: <CALJXSJpTkppvXAGb1nb5x3VFZ7CW-W9zmb3acvM=_+7SL06ixw@mail.gmail.com>
Subject: Re: Data recovery after RBD I/O error
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, ceph-users@lists.ceph.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 5, 2015 at 6:59 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> Secondly, I would highly recommend not using ANY non-cluster-aware FS on top
> of a clustered block device like RBD


For my use-case, this is just a single server using the RBD device. No
clustering involved on the BTRFS side of thing. However, it was really
useful to take snapshots (just like LVM) before modifying the
filesystem in any way.
