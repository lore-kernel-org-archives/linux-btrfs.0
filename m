Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38973 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760708AbbBIQiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 11:38:15 -0500
Received: by mail-lb0-f176.google.com with SMTP id u10so17531908lbd.7
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 08:38:13 -0800 (PST)
MIME-Version: 1.0
From: Tobias Holst <tobby@tobby.eu>
Date: Mon, 9 Feb 2015 17:37:53 +0100
Message-ID: <CAGwxe4hr=6WW=-JuqbitNZTHE9HV-G4=Q6RYh03mh2iLN6Qtzw@mail.gmail.com>
Subject: btrfs features
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I am just looking at the features enabled on my btrfs volume.
> ls /sys/fs/btrfs/[UUID]/features/
shows the following output:
> big_metadata  compress_lzo  extended_iref  mixed_backref  raid56

So "big_metadata" means I am not using "skinny-metadata",
"compress_lzo" means I am using compression. "raid56" means I am using
the experimental RAID-features of btrfs.



But the other two flags are a little bit unclear... I think "extended
_iref" is the "extref" feature of mkfs.btrfs - right?

I am not sure about the "mixed_backref" feature. What does it mean? Is
this the "mixed-bg"-feature of mkfs.btrfs?

Also I try to change these features. I am missing the skinny extends,
this can be enabled by "btrfstune -x [one device of my raid]",
correct?

And how can I enable the missing "no-holes"-feature on my volume?

Regards,
Tobias
