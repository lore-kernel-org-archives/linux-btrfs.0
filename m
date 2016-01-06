Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33454 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbcAFNVC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 08:21:02 -0500
Received: by mail-lb0-f174.google.com with SMTP id sv6so183367465lbb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 05:21:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <trinity-453ea1bf-27ee-494f-a3a8-c39fd6061a58-1451663085330@3capp-gmx-bs06>
References: <trinity-453ea1bf-27ee-494f-a3a8-c39fd6061a58-1451663085330@3capp-gmx-bs06>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Wed, 6 Jan 2016 14:20:41 +0100
Message-ID: <CAA7pwKMcRVo3uk8gBDAF1hpSjrrcZdZDbpPO8dufifKx9-Q=FA@mail.gmail.com>
Subject: Re: cannot repair filesystem
To: Jan Koester <jan.koester@gmx.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 January 2016 at 16:44, Jan Koester <jan.koester@gmx.net> wrote:
>
> Hi,
>
> if I try to repair filesystem got I'am assert. I use Raid6.
>
> Linux dibsi 3.16.0-0.bpo.4-amd64 #1 SMP Debian 3.16.7-ckt4-3~bpo70+1 (2015-02-12) x86_64 GNU/Linux

Raid6 wasn't completed until Linux 3.19 and I wouldn't call it stable yet.

https://btrfs.wiki.kernel.org/index.php/RAID56

I suggest you upgrade from Wheezy to Jessie and install the lastest
backports kernel and latest btrfs-progs from Git (there's no
stable-bpo for btrfs-tools) if you want to use raid56.
