Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34420 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdBFSkR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 13:40:17 -0500
Received: by mail-pg0-f49.google.com with SMTP id 14so30645065pgg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Feb 2017 10:40:17 -0800 (PST)
Date: Mon, 6 Feb 2017 10:39:44 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Alexander Tomokhov <alexoundos@ya.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Is it possible to have metadata-only device with no data?
Message-ID: <20170206183944.GA20714@vader>
References: <14453691486330921@web21h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <14453691486330921@web21h.yandex.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 06, 2017 at 12:42:01AM +0300, Alexander Tomokhov wrote:
> Is it possible, having two drives to do raid1 for metadata but keep data on a single drive only?

Chris had a patch for doing basically this that we were testing
internally, but I don't think he ever sent it to the mailing list.
