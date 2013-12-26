Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54386 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3LZFbK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Dec 2013 00:31:10 -0500
Received: by mail-ob0-f176.google.com with SMTP id vb8so7940819obc.21
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Dec 2013 21:31:08 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 26 Dec 2013 13:31:08 +0800
Message-ID: <CAMVG2ssVrki1M-90yh7uBaqsi4tfJxDgwffaNYYKLizZ+Z7zGA@mail.gmail.com>
Subject: Barrier remount failure
From: Daniel J Blueman <daniel@quora.org>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3.13-rc5, it's possible to remount a mounted BTRFS filesystem with
'nobarrier', but not possible to remount with 'barrier'.

Is this expected?

Many thanks,
  Daniel
-- 
Daniel J Blueman
