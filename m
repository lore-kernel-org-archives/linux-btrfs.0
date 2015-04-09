Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33303 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003AbbDITcF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 15:32:05 -0400
Received: by ignm3 with SMTP id m3so1446638ign.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 12:32:05 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Apr 2015 13:32:04 -0600
Message-ID: <CAJCQCtSsv42=dNMsh=F56x12sWbx=nc2Ktej1xGVzGmsysytSw@mail.gmail.com>
Subject: bug: proc mountinfo, findmnt, and subvol vs subvolid
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel-4.0.0-0.rc6.git0.1.fc22.i686


The short version is that if the top level subvolume is not mounted
first, any usage of subvolid= fails to show the subvolume in either
findmnt or /proc/self/mountinfo.

That is, only when the initial mount is the top level, any subsequent
mount using option subvolid= or subvol= will show the subvolume name
in findmnt and /proc/self/mountinfo.

This seems like a bug.

-- 
Chris Murphy
