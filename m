Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48507 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514Ab2J3MRM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 08:17:12 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so129164pad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 05:17:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508FC26A.1010206@pepinghege.net>
References: <508FB45B.9040101@gmail.com>
	<508FC26A.1010206@pepinghege.net>
Date: Tue, 30 Oct 2012 06:17:12 -0600
Message-ID: <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
Subject: Re: Why btrfs inline small file by default?
From: cwillu <cwillu@cwillu.com>
To: Felix Pepinghege <postfach@pepinghege.net>
Cc: ching <lsching17@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> If there is a lot of small files, then the size of metadata will be
>> undesirable due to deduplication
>
>
> Yes, that is a fact, but if that really matters depends on the use-case
> (e.g., the small files to large files ratio, ...). But as btrfs is designed
> explicitly as a general purpose file system, you usually want the good
> performance instead of the better disk-usage (especially as disk space isn't
> expensive anymore).

As I understand it, in basically all cases the total storage used by
inlining will be _smaller_, as the allocation doesn't need to be
aligned to the sector size.
