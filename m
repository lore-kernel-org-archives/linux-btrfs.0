Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35502 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758486AbdADOOf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 09:14:35 -0500
Received: by mail-vk0-f67.google.com with SMTP id x186so32909951vkd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jan 2017 06:14:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ae61834f-3157-dbef-5566-ac102d43cbc4@cn.fujitsu.com>
References: <20170103115813.GA3228@fedori> <ae61834f-3157-dbef-5566-ac102d43cbc4@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Wed, 4 Jan 2017 19:43:37 +0530
Message-ID: <CAKuJGC9wKcqSiWAxffb4MFjHR3K7Y1OijffGiBcnE-rLCpytNg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: btrfs-debugfs: Display usage hint with no arguments
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think we can achieve above help string with the help of custom usage
function instead of using argparse default usage.  I'll check and send
a new patch.

----
Cheers,
Lakshmipathi.G
FOSS Programmer.
www.giis.co.in


On Wed, Jan 4, 2017 at 6:14 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> What about changing current help string to:
>
> btrfs-debugfs -b|-f path
> or
> btrfs-debugfs -h
>
> Thanks,
> Qu
