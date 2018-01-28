Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:59643 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751273AbeA1K1e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Jan 2018 05:27:34 -0500
Date: Sun, 28 Jan 2018 11:27:32 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: degraded permanent mount option
Message-ID: <20180128102732.GA20798@polanet.pl>
References: <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <7c95b4ae-f65e-b31d-f907-5eae5c60c49a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <7c95b4ae-f65e-b31d-f907-5eae5c60c49a@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 28, 2018 at 11:06:06 +0300, Andrei Borzenkov wrote:

>> All systemd has to do is leave the mount alone that the kernel has 
>> already done,
> 
> Are you sure you really understand the problem? No mount happens because
> systemd waits for indication that it can mount and it never gets this
> indication.

And even after successful manual mount (with -o degraded) btrfs.ko
insists that the device is not ready.

That schizophrenia makes systemd umount that immediately, because this
is the only proper way to handle missing devices (only the failed ones
should go r/o). And there is really nothing systemd can do about this,
until underlying code stops lying, unless we're going back to 1990s when
devices were never unplugged or detached during system uptime. But even
floppies could be ejected without system reboot.

BTRFS is no exception here - when marked as 'not available',
don't expect it to be kept used. Just fix the code to match reality.

-- 
Tomasz Pala <gotar@pld-linux.org>
