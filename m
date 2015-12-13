Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36506 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbbLMTeu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 14:34:50 -0500
Received: by obber4 with SMTP id er4so34477729obb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 11:34:50 -0800 (PST)
MIME-Version: 1.0
From: Ivan Sizov <sivan606@gmail.com>
Date: Sun, 13 Dec 2015 22:34:30 +0300
Message-ID: <CAMG9ccy6L+VmrSW5FSgTi-a=jehsefhZsWE9XBAT1ejcjN271A@mail.gmail.com>
Subject: Determine is file a reflink or not
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there a way to view the CoW structure, e.g. to know is file just a
reflink or it was modified? I copied many files from snapshot with
--reflink=always I and want to know which files was modified since the
copying. Calculating hashsums seems to be too long thing.

-- 
Ivan Sizov
