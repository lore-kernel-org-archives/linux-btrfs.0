Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:36722 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752150AbcKSJDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Nov 2016 04:03:53 -0500
Reply-To: kreijack@inwind.it
Subject: Re: RFC: raid with a variable stripe size
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
 <CANznX5EvKzySaFrRFOULTkUqGGMRhKAQZEphMD9Kww_iOkN25A@mail.gmail.com>
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <38873cdc-f017-b7db-0a0b-a0f150e9bb2e@inwind.it>
Date: Sat, 19 Nov 2016 09:55:40 +0100
MIME-Version: 1.0
In-Reply-To: <CANznX5EvKzySaFrRFOULTkUqGGMRhKAQZEphMD9Kww_iOkN25A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-18 21:32, Janos Toth F. wrote:
> Based on the comments of this patch, stripe size could theoretically
> go as low as 512 byte:

AFAIK the kernel uses a pagesize of 4k (or greater in some architecture). So doesn't make sense to use a so small size.

GB

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
