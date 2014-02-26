Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51786 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaBZCBY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 21:01:24 -0500
Received: by mail-qc0-f174.google.com with SMTP id e16so407661qcx.5
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 18:01:24 -0800 (PST)
MIME-Version: 1.0
Reply-To: madthanu@gmail.com
From: thanumalayan mad <madthanu@gmail.com>
Date: Tue, 25 Feb 2014 20:01:04 -0600
Message-ID: <CAJ6LpRpbKyETTOicfXjTXe15u0pqwe7rMkLcAUKrH1xyHOB1Vw@mail.gmail.com>
Subject: Ordering of directory operations maintained across system crashes in Btrfs?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Slightly complicated question.

Assume I do two directory operations in a Btrfs partition (such as an
unlink() and a rename()), one after the other, and a crash happens
after the rename(). Can Btrfs (the current version) send the second
operation to the disk first, so that after the crash, I observe the
effects of rename() but not the effects of the unlink()?

I think I am observing Btrfs re-ordering an unlink() and a rename(),
and I just want to confirm that my observation is true. Also, if Btrfs
does send directory operations to disk out of order, is there some
limitation on this? Like, is this restricted to only unlink() and
rename()?

I am looking at some (buggy) applications that use Btrfs, and this
behavior seems to affect them.

Thanks,
Thanu
