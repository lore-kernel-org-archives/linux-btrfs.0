Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:39662 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdIRIqA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 04:46:00 -0400
Subject: Re: ERROR: parent determination failed (btrfs send-receive)
To: Dave <davestechshop@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
 <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
 <CAH=dxU4yTdKQwZX3L-oOMs2ZYiR82m1-F0GhbSU4SV_K2jrBGA@mail.gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <bf5202e0-d2f9-4383-fc1d-42a432eb1a8e@cobb.uk.net>
Date: Mon, 18 Sep 2017 09:45:56 +0100
MIME-Version: 1.0
In-Reply-To: <CAH=dxU4yTdKQwZX3L-oOMs2ZYiR82m1-F0GhbSU4SV_K2jrBGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/09/17 07:10, Dave wrote:
> For my understanding, what are the restrictions on deleting snapshots?
> 
> What scenarios can lead to "ERROR: parent determination failed"?

The man page for btrfs-send is reasonably clear on the requirements
btrfs imposes. If you want to use incremental sends (i.e. the -c or -p
options) then the specified snapshots must exist on both the source and
destination. If you don't have a suitable existing snapshot then don't
use -c or -p and just do a full send.

> I use snap-sync to create and send snapshots.
> 
> GitHub - wesbarnett/snap-sync: Use snapper snapshots to backup to external drive
> https://github.com/wesbarnett/snap-sync

I am not familiar with this tool. Your question should be sent to the
author of the tool, if that is what is deciding what -p and -c options
are being used.

Personally I use and recommend btrbk. I have never had this issue and
the configuration options let me limit the snapshots it saves on both
the source and destination disks separately (so I keep fewer on the
source than on the backup disk).

Graham
