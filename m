Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:61061 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaCCRbL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 12:31:11 -0500
Received: by mail-qc0-f178.google.com with SMTP id i8so4171557qcq.9
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 09:31:10 -0800 (PST)
MIME-Version: 1.0
Reply-To: madthanu@gmail.com
In-Reply-To: <CAJ6LpRpbKyETTOicfXjTXe15u0pqwe7rMkLcAUKrH1xyHOB1Vw@mail.gmail.com>
References: <CAJ6LpRpbKyETTOicfXjTXe15u0pqwe7rMkLcAUKrH1xyHOB1Vw@mail.gmail.com>
From: thanumalayan mad <madthanu@gmail.com>
Date: Mon, 3 Mar 2014 11:30:50 -0600
Message-ID: <CAJ6LpRpUdjrT8JZBJVXmRQEjz3VQ8o3OjKvMediN3V3OT_i08A@mail.gmail.com>
Subject: Re: Ordering of directory operations maintained across system crashes
 in Btrfs?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any ideas about this? Guessed-up, not-entirely-sure answers would help too.

An example application bug that would be affected by this is from
LevelDB: https://code.google.com/p/leveldb/issues/detail?id=189

Thanks,
Thanu

On Tue, Feb 25, 2014 at 8:01 PM, thanumalayan mad <madthanu@gmail.com> wrote:
> Hi all,
>
> Slightly complicated question.
>
> Assume I do two directory operations in a Btrfs partition (such as an
> unlink() and a rename()), one after the other, and a crash happens
> after the rename(). Can Btrfs (the current version) send the second
> operation to the disk first, so that after the crash, I observe the
> effects of rename() but not the effects of the unlink()?
>
> I think I am observing Btrfs re-ordering an unlink() and a rename(),
> and I just want to confirm that my observation is true. Also, if Btrfs
> does send directory operations to disk out of order, is there some
> limitation on this? Like, is this restricted to only unlink() and
> rename()?
>
> I am looking at some (buggy) applications that use Btrfs, and this
> behavior seems to affect them.
>
> Thanks,
> Thanu
