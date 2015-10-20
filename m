Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34449 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbJTDN1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 23:13:27 -0400
Received: by lbbwb3 with SMTP id wb3so4601412lbb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 20:13:25 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 19 Oct 2015 23:13:25 -0400
Message-ID: <CA+X5Wn7C-0O5TRn6fpBFdst6=-cJ2zdn0RPQD3n97MR7NrZxsg@mail.gmail.com>
Subject: N-Way (traditional) RAID-1 development status
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wanted to see if there's active development on N-Way (traditional) RAID-1.

By this, I mean that RAID-1 across "n" disks traditionally means "n"
copies of data, but btrfs currently implements RAID-1 as "2" copies of
data.  So, unlike traditional RAID-1, losing 2 drives in a many drive
array might cause data loss.  It's been mentioned before that N-Way
(traditional) RAID-1 should eventually be implemented through btrfs.
