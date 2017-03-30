Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:58160 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933482AbdC3PxX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 11:53:23 -0400
Date: Thu, 30 Mar 2017 12:46:40 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [v4] btrfs: add missing memset while reading compressed inline
 extents
Message-ID: <20170330154639.GB21626@pirotess.Home>
References: <1489182344-29818-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1489182344-29818-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/Mar/2017 16:45, Zygo Blaxell wrote:
> This is a story about 4 distinct (and very old) btrfs bugs.
> 
<...>

Tested-by: Ismael Luceno <ismael@iodev.co.uk>

I encountered the issue in the wild; it caused frequent segfaults
at ld.so after some hours of operation, as well as integrity check
failures. A quick inspection revealed corruption in the ELF headers,
with garbage where there should be zeros.

I managed to reproduce the issue right away by enabling page poisoning,
and the problem effectively goes away when applying the patch.
