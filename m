Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35320 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbcDWAli (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 20:41:38 -0400
Received: by mail-wm0-f42.google.com with SMTP id e201so33511194wme.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 17:41:37 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 Apr 2016 20:41:36 -0400
Message-ID: <CAD=QJKh50oFh+eEDte4BncgwRuiuJmC1wyiPG3HBVqOkLD2Wng@mail.gmail.com>
Subject: primary location of btrfs-progs changelog: The wiki?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm just wondering where the primary location of the btrfs-progs
changelog is located, because I'd like to include upstream changes in
the Debian package.  Is it really the wiki?  If so, it would seem my
options are copying+pasting with every release, or writing a script to
download the page, convert it to text, and then do something like cut
everything before By version (btrfs-progs) and everything after By
version (linux kernel).

Sincerely,
Nicholas
