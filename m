Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35479 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbcCJIYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 03:24:46 -0500
Received: by mail-io0-f180.google.com with SMTP id g203so97230867iof.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 00:24:45 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 10 Mar 2016 01:24:44 -0700
Message-ID: <CAJCQCtRzt-BeoW9KNQC3kmBXw8MoydJv7Qy8fu0HmF3hAOgFRQ@mail.gmail.com>
Subject: [bug] df returns 100% used for empty mixed block group filesystem
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel 4.5.0 rc7
btrfs-progs-4.4.1-1

Summary: A new empty mixed block group "-M" filesystem shows up as
100% full with regular df (gnu coreutils 8.24). Pretty sure this is
not a regression, but no regression testing done.


https://bugzilla.kernel.org/show_bug.cgi?id=114281


-- 
Chris Murphy
