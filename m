Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37009 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750854AbdL1UST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 15:18:19 -0500
Date: Thu, 28 Dec 2017 21:18:07 +0100
From: David Disseldorp <ddiss@suse.de>
To: Ceriel Jacobs <linux-ide@crashplan.pro>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Project idea: reduce boot time/RAM usage: option to
 disable/delay raid6_pq and xor kmod
Message-ID: <20171228211807.60f115f4@suse.de>
In-Reply-To: <6f082a1d-ed15-2583-fabf-9aa7c80baef0@crashplan.pro>
References: <6f082a1d-ed15-2583-fabf-9aa7c80baef0@crashplan.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 24 Dec 2017 13:31:40 +0100, Ceriel Jacobs wrote:

> Saving:
> 1. ± 0.4 seconds of boot time (10% of boot until root)
> 2. ± 150k of RAM
> 3. ± 75k of disk space

Thanks for bringing this up - I'm also particularly frustrated by the
boot delay caused by the raid6 algorithm benchmark (1).

> New kernel command-line parameters?
> a.) disable, like:
>      - btrfs=noraid6_pq
>      - btrfs=noraid (=no xor at all)
> b.) delay raid6_pq and xor module loading, for cases where root mount 
> doesn't need raid6_pq and/or xor.

c) It might not help with (2) or (3), but I'd be happy with an option to
preselect the raid6 algorithm, so that the benchmark didn't run on each
boot.

Cheers, David
