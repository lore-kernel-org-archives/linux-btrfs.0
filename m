Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f43.google.com ([209.85.216.43]:35901 "EHLO
	mail-vn0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbG2DOC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 23:14:02 -0400
Received: by vnk197 with SMTP id 197so49979716vnk.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 20:14:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn63oURx2yKAJS4cCR+9v8fdx950RervzmXqTtXbHXn+gg@mail.gmail.com>
References: <CA+X5Wn63oURx2yKAJS4cCR+9v8fdx950RervzmXqTtXbHXn+gg@mail.gmail.com>
Date: Tue, 28 Jul 2015 21:14:00 -0600
Message-ID: <CAJCQCtSJxQ75UbYpNk-NC8j4z63RmToHRhODv9xbhM9muyqC0w@mail.gmail.com>
Subject: Re: mkfs.btrfs with invalid -d option uses default single drive,
 rather than errors
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 8:16 PM, james harvey <jamespharvey20@gmail.com> wrote:
> Doing some fast-paced benchmarking of lots of raid levels, some in a
> kvm, some via RDMA access over InfiniBand using different procotols,
> etc.
>
> Was shocked to see horrible raid0 performance in one of the tests.
> Looked back through the logs and found:
>
> (Note that I typo'ed -d raid**e**0
>
> =====
> $ sudo mkfs.btrfs -f -m raid0 -d raide0 /dev/vda2 /dev/vdb1 /dev/vdc1
> Unknown profile raide0

For raid0, at least going to single is a lower risk of data loss. But
what if the user specified raid1 but instead single and hence higher
risk of data loss? Probably better to fail the command than ignore -d
switch and continue.


-- 
Chris Murphy
