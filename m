Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35139 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaAIReY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 12:34:24 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so3400981pdj.8
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 09:34:24 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 9 Jan 2014 18:34:23 +0100
Message-ID: <CAPpBBdNKSUHCtM3fk7=ujJFZSL8LMf_iQXdZ-O-bXcTRN69c3g@mail.gmail.com>
Subject: Re: How does btrfs handle bad blocks in raid1?
From: George Eleftheriou <eleftg@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> claiming that RAID-10 (with 2-way mirroring) is guaranteed to survive
> an arbitrary 2-device failure is incorrect.

Yes, you are right.  I didn't mean "any 2 devices". I should have
added "from different mirrors" :)
