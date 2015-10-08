Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:33281 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbJHCfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Oct 2015 22:35:10 -0400
Received: by ykft14 with SMTP id t14so36983512ykf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2015 19:35:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 8 Oct 2015 08:05:09 +0530
Message-ID: <CAH-HCWV2mO1FFRGPh+jh2TrZMYV-7w7MwytSV4WZ33-9PW=qRw@mail.gmail.com>
Subject: Using BtrFS and backup tools for keeping two systems in sync
From: Shriramana Sharma <samjnaa@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I see there are some backup tools taking advantage of BtrFS's
incremental send/receive feature:
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup. [BTW Ames
Cornish's ButterSink (https://github.com/AmesCornish/buttersink) seems
to be missing from that page.]

Now I'd like to know if anyone has evolved some good practices w.r.t
maintaining the data of two systems in sync using this feature of
BtrFS. What I have in mind is: I work on my desktop by default, and
for ergonomics reasons only use my laptop when I need the mobility.
I'd like to keep the main data (documents I create, programs I write
etc) in sync between the two. (The profile data such as in the ~/.*
hidden folders had better stay separate though, I guess.)

I figure with the existing tools it would not be too difficult to
maintain a synced set of snapshots between the two systems if I only
use the desktop vs laptop alternatingly and sync at each switchover,
but the potential problem only would come if I modify both (something
like having to do git merge, I guess).

Has anyone come across this situation and evolved any policies to handle it?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
