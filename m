Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:51444 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaK3Dde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 22:33:34 -0500
Received: by mail-qg0-f51.google.com with SMTP id l89so6250761qgf.10
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 19:33:34 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 09:03:14 +0530
Message-ID: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
Subject: Possible to undo subvol delete?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

IIUC with BtrFS while it is possible to easily undelete a file or
ordinary directory if a snapshot of the containing subvol exists, it
seems that it's not elementary to undelete a subvol itself, because
all subvols are under the root-level subvol (id 0 or 5, see my other
q) but even snapshotting the root subvol will not snapshot any subvols
under it.

So is there any way to undo a subvol delete?

[If no, then ordinary users should probably prefer regular directories
to subvols.]

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
