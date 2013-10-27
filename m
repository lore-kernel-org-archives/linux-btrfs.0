Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:55843 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3J0Rdr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 13:33:47 -0400
Received: by mail-vb0-f43.google.com with SMTP id g10so3952159vbg.2
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 10:33:47 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 27 Oct 2013 18:33:47 +0100
Message-ID: <CAD_cGvGG9KPastZr1QCE_d0rmR=saj9Drj25hAzSzRkg6oEL2g@mail.gmail.com>
Subject: Non-intelligent behaviour on device delete with multiple devices?
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Today I tried removing two devices from a multidevice btrfs RAID10
volume using the following command:
---
btrfs device delete /dev/sdl /dev/sdk /btrfs
---

It first removed device sdl and then sdk. What I did not expect
however was that btrfs didn't remove sdk from the available drives
when removing and rebalancing data from the first device. This
resultated in that over 300GB of data was actually added to sdk during
removal of sdl, only to make the removal process of sdk longer.

This seems to me as a rather non-intelligent way to do this. I would
expect that all drives given as input to the btrfs device delete
command was removed from the list of drives available for rebalancing
of the data during removal of the drives.


Regards,
Hans-Kristian Bakke
