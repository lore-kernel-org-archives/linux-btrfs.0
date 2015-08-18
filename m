Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35277 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbbHRPki (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 11:40:38 -0400
Received: by igbjg10 with SMTP id jg10so83430628igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 08:40:38 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Aug 2015 11:40:37 -0400
Message-ID: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
Subject: btrfs-image gets stuck, using 100%, looping on bad file descriptor
From: Timothy Normand Miller <theosib@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've filed a bug report on this:

https://bugzilla.kernel.org/show_bug.cgi?id=103081

-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
