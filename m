Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34068 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbK1Jkk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 04:40:40 -0500
Received: by lffu14 with SMTP id u14so150200723lff.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 01:40:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
	<20151127204305.GE24333@carfax.org.uk>
	<CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
Date: Sat, 28 Nov 2015 11:40:38 +0200
Message-ID: <CAK5rZE7j-4QMFjvn-FzWXDdqegvkQ9=HGoLUey6Kw4OMsQ0uZQ@mail.gmail.com>
Subject: Re: BTRFS: could not find root 8
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> After upgrading from systemd227 to 228
>>> these messages began to show up during boot:
>>> [   24.652118] BTRFS: could not find root 8
>>> [   24.664742] BTRFS: could not find root 8

> b. For the OP, is it possible quotas was ever enabled on this file system?

Quotas have never been enabled since creation of this fs.
