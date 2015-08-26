Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34717 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbbHZI4F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 04:56:05 -0400
Received: by laba3 with SMTP id a3so114962718lab.1
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 01:56:03 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 26 Aug 2015 10:56:03 +0200
Message-ID: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
Subject: Understanding BTRFS storage
From: George Duffield <forumscollective@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Is there a more comprehensive discussion/ documentation of Btrfs
features than is referenced in
https://btrfs.wiki.kernel.org/index.php/Main_Page...I'd love to learn
more but it seems there's no readily available authoritative
documentation out there?

I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs based
solution that will involve duplicating a data store on a second
machine for backup purposes (the machine is only powered up for
backups).

Two quick questions:
- If I were simply to create a Btrfs volume using 5x3TB drives and not
create a raid5/6/10 array I understand data would be striped across
the 5 drives with no reduncancy ... i.e. if a drive fails all data is
lost?  Is this correct?

- Is Btrfs RAID10 (for data) ready to be used reliably?

*/
