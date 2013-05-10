Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:45492 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3EJIaa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 04:30:30 -0400
Received: by mail-vb0-f51.google.com with SMTP id x16so3337208vbf.10
        for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 01:30:29 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 May 2013 10:30:29 +0200
Message-ID: <CAFvQSYQFPtoAXncHopDg4W=Br5Cy3EjR+EKrhUZP0FFg0Fh09A@mail.gmail.com>
Subject: Can btrfs cope with a high number of snapshpts (continuous snapshotting)?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am looking for a file-system which is able to provide continuous
snapshotting like some log-structured file-systems do.

The btrfs snapshot-mechanism seems to be what I am looking for, in
combination with a daemon monitoring the free space it should be
possible to create a snapshot every 15min and delete snapshots as the
free space is below some threshold.

Is btrfs suitable for such a high number of snapshots, or will it have
negative implications (like huge metadata, ...)?

Thank you in advance, Clemens
