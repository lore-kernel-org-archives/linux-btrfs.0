Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38770 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbbDITiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 15:38:20 -0400
Received: by igbqf9 with SMTP id qf9so725180igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 12:38:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSsv42=dNMsh=F56x12sWbx=nc2Ktej1xGVzGmsysytSw@mail.gmail.com>
References: <CAJCQCtSsv42=dNMsh=F56x12sWbx=nc2Ktej1xGVzGmsysytSw@mail.gmail.com>
Date: Thu, 9 Apr 2015 13:38:19 -0600
Message-ID: <CAJCQCtRnS_s2MxpvmrPv9_-Rn6-kfJ0wLxhgbDKoO0DtWi9Uig@mail.gmail.com>
Subject: Re: bug: proc mountinfo, findmnt, and subvol vs subvolid
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another way to put this is, the only reliable way to mount and get
subvolume info in findmnt and /proc is by using subvol=.

When using subvolid=, the subvolume info isn't available unless the
initial mount is the top level (ID 5).


-- 
Chris Murphy
