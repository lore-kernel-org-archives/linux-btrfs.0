Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:61040 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3EKM12 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 08:27:28 -0400
Received: by mail-vb0-f51.google.com with SMTP id x16so4067271vbf.24
        for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 05:27:27 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 11 May 2013 14:27:27 +0200
Message-ID: <CAFvQSYSQGiw74PV0HRHw4zoYre1qwOQ0DnMRwWB1e69tcXd1OQ@mail.gmail.com>
Subject: "unlinked 10 orphans" - something to worry about?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I frequently get messages like "unlinked 10 orphans" in syslog
(running linux 3.9.1), although I have never had a power outage nor a
kernel crash.
Is this something to worry about, or just a usual clean-up information?

Thank you in advance, Clemens
