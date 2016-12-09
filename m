Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36887 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbcLIH4g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 02:56:36 -0500
Received: by mail-wm0-f42.google.com with SMTP id t79so14573892wmt.0
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 23:56:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r2Q3pz8FQrKgij_fWTBw7p2YRB6DqYrXzoOZ-g0htiKAw@mail.gmail.com>
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org> <CAEtw4r2Q3pz8FQrKgij_fWTBw7p2YRB6DqYrXzoOZ-g0htiKAw@mail.gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Fri, 9 Dec 2016 08:56:33 +0100
Message-ID: <CAEtw4r3mn9YDcwMApN1+akNZRUo9WU4XkfV_+5jQOU_1ifv19g@mail.gmail.com>
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 2016-12-08 16:11 GMT+01:00 Swâmi Petaramesh <swami@petaramesh.org>:
>
> Then it took another 48 hours just for "loading the hashes of duplicate
> extents".
>

This issue i adressing currently with the following patches:
https://github.com/Floyddotnet/duperemove/commits/digest_trigger

Tested with a 3,9 TB directory, with 4723 objects:

old implementation of dbfile_load_hashes took 36593ms
new implementation of dbfile_load_hashes took 11ms

You can use this versions save. But i have to do more work. (for
example a migrationscript for existing hashfiles)
