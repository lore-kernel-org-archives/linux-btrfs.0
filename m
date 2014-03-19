Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60713 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbaCSHwi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 03:52:38 -0400
Received: by mail-vc0-f182.google.com with SMTP id ks9so8824556vcb.27
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 00:52:37 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 Mar 2014 08:52:37 +0100
Message-ID: <CAC+fKQUPg7kwNgW+0E1h4uVTuDvp9ki=X4Ht=w3EVDQopdFDoA@mail.gmail.com>
Subject: Another crash when deleting a large number of snapshots
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This kind of crashes happens me very often when I delete a large
number (+200) of snapshots at once.
There is a very high IO for a while, and after that, the system
freezed at intervals. I had to reboot the system to get it responsive
again.

Versions used:
kernel-3.13.6-200.fc20.x86_64
btrfs-progs-3.12-1.fc20.x86_64

The log:
http://ur1.ca/gvr3j
