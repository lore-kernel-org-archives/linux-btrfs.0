Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:39903 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757685AbdLRCue (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 21:50:34 -0500
Received: by mail-ot0-f173.google.com with SMTP id v21so12256883oth.6
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 18:50:34 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 17 Dec 2017 19:50:33 -0700
Message-ID: <CAJCQCtScin-9AomqOwiSTwj=5rCeJW12jv8rv8taxwUq+AX5Lw@mail.gmail.com>
Subject: btrfs check lowmem crash, backref.c:466: __add_missing_keys:
 Assertion `ref->root_id` failed
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is v4.14.

I've filed a bug which contains the build steps, versions. It's
crashing on all volumes I try it on so far.


-- 
Chris Murphy
