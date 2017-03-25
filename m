Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:48402 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdCYXbc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Mar 2017 19:31:32 -0400
Subject: Re: send snapshot from snapshot incremental
To: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>,
        linux-btrfs@vger.kernel.org
References: <p18jqd-a0m.ln1@aldebaran.xundeenergie.at>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b45f37ec-b8a4-64a0-9bdf-90f68376f0ce@mendix.com>
Date: Sun, 26 Mar 2017 00:31:27 +0100
MIME-Version: 1.0
In-Reply-To: <p18jqd-a0m.ln1@aldebaran.xundeenergie.at>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jakob,

On 03/25/2017 11:37 PM, Jakob Schürz wrote:
> Hi there!
> 
> I asked one or two years ago for the ability of btrfs to use btrfs
> send|receive with a parent-subvolume from a snapshot from a snapshot.
> 
> The thing is, if i take a snapshot from my system, transfer it with
> btrfs send|receive  to an external HD on USB-Port, make some changes to
> my system, which destroy my whole system, i can boot in the former taken
> snapshot and work from there, as if nothing happened.
> 
> This part works.
> 
> BUT if i take a snapshot from the system, and want to transfer it to the
> external HD, i can not set a parent subvolume, because there isn't any.
> 
> The problem was on my last question, there are missing
> tansactional-numbers or something similar... I'm not a programmer, but i
> use btrfs very extensive and wrote a fancy python-script and a
> gnome-shell-extension and a fuse-filesystem to do enhanced and
> userfriendly snapshots an backups with btrfs - also for non-programmer
> users... something similar userfriendly as time-machine for apple does.
> 
> And one missing feature is the described problem above... booting into
> an older snapshot and transfer a snapshot from this one lead to a full
> transfer - even if there is a transferred snapshot on the external HD.
> 
> I hope, i described my problem understandable...

Yes, if you make a writable snapshot, and then start creating a readonly
snapshot for send/receive from that, you actually start another
"timeline" in which the parent relationship for the snapshots is
replaced by the ID of the new writable one.

Send/receive also has a clone option, which lets you specify any other
subvolume that is present on the local and the remote system as well,
using the -c option. I'd recommend playing around and testing that
option, to see if, for the first send, you can refer to the latest
available snapshot of the previous "timeline". When getting this right,
it should prevent sending all data that was already present in the old
snapshot.

HTH,
-- 
Hans van Kranenburg
