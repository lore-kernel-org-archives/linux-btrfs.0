Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33633 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbcETTaX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 15:30:23 -0400
Received: by mail-oi0-f48.google.com with SMTP id v145so194370071oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 12:30:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6BBAAABC-616F-48A6-BDF2-70B23B8E0D72@me.com>
References: <6BBAAABC-616F-48A6-BDF2-70B23B8E0D72@me.com>
Date: Fri, 20 May 2016 13:30:22 -0600
Message-ID: <CAJCQCtSh-OqADqPZU1s8HjbvOBmoGB+swHNAS3FanQr5WQoyzw@mail.gmail.com>
Subject: Re: btrfs restore fails because of NO SPACE
From: Chris Murphy <lists@colorremedies.com>
To: Wolf Bublitz <wolf.bublitz@me.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What versions for kernel and btrfs-progs?

Have you tried only '-o ro,recovery' ? What kernel messages do you get for this?

Failure to read chunk tree message is usually bad. If you have a
recent enough btrfs-progs, try 'btrfs check' on the volume without
--repair and post the results; recent would be 4.4.1 or better.

Also a good idea is to post btrfs-show-super -f, there's a scant
possibility there's more than one backup chunk root and possible to
explicitly use an older one (but btrfs check--chunk-root is only in
v4.5 of btrfs-progs).



Chris Murphy
