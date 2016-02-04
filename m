Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36441 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbcBDUGA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 15:06:00 -0500
Received: by mail-lf0-f53.google.com with SMTP id 78so43792766lfy.3
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 12:05:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160106013134.GA13956@localhost>
References: <20160104170553.GA4975@localhost>
	<568B2304.8090205@cn.fujitsu.com>
	<CAP-bSRYB4mH1TK9uQnHQaMazxOnMcmCYkhF9xXmrVHPbveZLQQ@mail.gmail.com>
	<568C6678.8020803@cn.fujitsu.com>
	<20160106013134.GA13956@localhost>
Date: Thu, 4 Feb 2016 20:05:59 +0000
Message-ID: <CAP-bSRbueHoWAn1Djyj9bpzcpBX-7J=RzO6vZOm6i3Bx70hRbg@mail.gmail.com>
Subject: Re: Crash, boot mount failure: "corrupt leaf, slot offset bad"
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had another btrfs crash with identical symptoms. This time I managed
to reproduce the crash and identify the root cause. It turns out that
the Apple boot firmware is buggy and leaves wifi DMA turned on, which
randomly corrupts memory after Linux is running.
https://bugzilla.kernel.org/show_bug.cgi?id=111781

So btrfs is not to blame after all.
