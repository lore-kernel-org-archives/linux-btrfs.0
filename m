Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:59232 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaHaBzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Aug 2014 21:55:46 -0400
Received: by mail-qc0-f173.google.com with SMTP id w7so4028443qcr.18
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Aug 2014 18:55:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 31 Aug 2014 07:25:45 +0530
Message-ID: <CAH-HCWXVn3pyejxzy7_sQmGPwARf6hLxYdHPWBrhd5bkZvExpQ@mail.gmail.com>
Subject: Change "total" in btrfs filesystem df output to "alloc"
From: Shriramana Sharma <samjnaa@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello. There seem to be lots of questions in various forums re the
output of btrfs fi df -- especially w.r.t. the usage of the word
"total". For example see https://community.oracle.com/thread/2459838

I feel it would make the intent clearer if "total" were changed to
"alloc" or "allocated" (if the short form is felt unclear). It would
also help people understand the output of regular df on a btrfs system
since one can understand easier that pre-allocated space would count
as "used" space as it is not free!

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
