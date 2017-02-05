Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49170 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdBEVzq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 16:55:46 -0500
Subject: Re: Is it possible to have metadata-only device with no data?
To: Alexander Tomokhov <alexoundos@ya.ru>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <14453691486330921@web21h.yandex.ru>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <0dbbe15a-59f7-ef0e-1ed6-83fec7ef165a@mendix.com>
Date: Sun, 5 Feb 2017 22:55:42 +0100
MIME-Version: 1.0
In-Reply-To: <14453691486330921@web21h.yandex.ru>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/05/2017 10:42 PM, Alexander Tomokhov wrote:
> Is it possible, having two drives to do raid1 for metadata but keep data on a single drive only?

Nope.

Would be a really nice feature though... Putting metadata on SSD and
bulk data on HDD...

-- 
Hans van Kranenburg
