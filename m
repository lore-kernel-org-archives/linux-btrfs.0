Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:32945 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbbFPVOz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 17:14:55 -0400
Received: by yhpn97 with SMTP id n97so20574844yhp.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 14:14:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mlpb8i$dus$1@ger.gmane.org>
References: <mlpb8i$dus$1@ger.gmane.org>
Date: Tue, 16 Jun 2015 15:14:54 -0600
Message-ID: <CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
From: Chris Murphy <lists@colorremedies.com>
To: Christian <cdysthe@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I experienced the errors 400 problem on an HDD and how I fixed it is
in comment 2 in this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=90071

The gist is to find out what file is affected by finding the
path/filename for the inode with the error and then deleting it.
You'll need to recover the file from backups. Once you do this the
problem is resolved, the file system itself is OK. (At least it was in
my case.)

I don't know that the source of the problem you're having has anything
to do with trim, but I recommend not using discard or fstrim at all
until you isolate  what's causing it. There are some trim bugs that
have been fixed in newer kernels that sound like the problem you're
having; and there are definitely some SSDs out there with trim
problems where the wrong sectors get trimmed. It shows up as files
with 512 byte holes of zeros in them. Of course, that's when the bug
affects data. If it affects metadata it can obliterate the file system
beyond repair.

Chris Murphy
