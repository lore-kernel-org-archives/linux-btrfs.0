Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44284 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FAVHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Jun 2013 17:07:55 -0400
Received: by mail-wi0-f173.google.com with SMTP id hi5so1628093wib.6
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jun 2013 14:07:54 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 Jun 2013 14:07:53 -0700
Message-ID: <CAN05THTWG_jYHti7aUcz_WH97OvoVfCoz7Wuc8Hh2katqm2JmQ@mail.gmail.com>
Subject: RADI6 questions
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi List,

I have a filesystem that is spanning about 10 devices.
It is currently using RAID1 for both data and metadata.

In order to get higher availability and be able to handle multi device failures
I would like to change from RAID1 to RAID6.


Is it possible/stable/supported/recommended to change data from RAID1 to RAID6 ?
(I assume "btrfs fi balance ..."  is used for this?)

Metadata is currently RAID1, is it supported to put metadata as RAID6 too?
It would be "odd" to have lesser protection for metadata than data.
Optimally I would like a mode where metadata is mirrored onto all the
spindles in the filesystem, not just 2 in RAID1 or n in RAID6.


Im running a 3.8.0 kernel.


regards
ronnie sahlberg
