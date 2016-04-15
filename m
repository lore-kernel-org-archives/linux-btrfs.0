Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36016 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbcDOBzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 21:55:19 -0400
Received: by mail-ig0-f171.google.com with SMTP id f1so8683536igr.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 18:55:18 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Apr 2016 19:55:17 -0600
Message-ID: <CAJCQCtSUj0fcsH7AUREnm7KzdDZiL2pW9MpSkKiQBcV9-J9nXQ@mail.gmail.com>
Subject: RFE: btrfs subvolume list -t, include marker for snapshots, and
 whether they are ro
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm realizing instead of doing 'btrfs subvolume -t' and then 'btrfs
subvolume -tr' and comparing, it would be better if -t just had a
column for whether a subvolume is ro. And maybe it's useful to know if
a subvolume is a snapshot or not (?). I'm not super picky about the
last one. But being able to see if it's ro or not is a nice to have.

In particular on openSUSE with snapper where there's a prolific amount
of snapshots, and the naming convention doesn't indicate whether
something is ro or not.

-- 
Chris Murphy
