Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:50816 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753507AbdKNMs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 07:48:58 -0500
Date: Tue, 14 Nov 2017 17:48:56 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Klaus Agnoletti <klaus@agnoletti.dk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: A partially failing disk in raid0 needs replacement
Message-ID: <20171114174856.12ae346f@natsu>
In-Reply-To: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 Nov 2017 10:36:22 +0200
Klaus Agnoletti <klaus@agnoletti.dk> wrote:

> Obviously, I want /dev/sdd emptied and deleted from the raid.

  * Unmount the RAID0 FS

  * copy the bad drive using `dd_rescue`[1] into a file on the 6TB drive
    (noting how much of it is actually unreadable -- chances are it's mostly
    intact)

  * physically remove the bad drive (have a powerdown or reboot for this to be
    sure Btrfs didn't remember it somewhere)

  * set up a loop device from the dd_rescue'd 2TB file

  * run `btrfs device scan`

  * mount the RAID0 filesystem

  * run the delete command on the loop device, it will not encounter I/O
    errors anymore.


[1] Note that "ddrescue" and "dd_rescue" are two different programs for the
same purpose, one may work better than the other. I don't remember which. :)

-- 
With respect,
Roman
