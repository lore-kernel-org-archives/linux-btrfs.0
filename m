Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:60445 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3KGLnQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 06:43:16 -0500
Received: by mail-oa0-f50.google.com with SMTP id j17so719822oag.37
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 03:43:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMajw1MVmO5dbkDB7Wj1J-O0mTE-q6xyo1Do83gQk8RLX2dnpQ@mail.gmail.com>
References: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com>
	<CAMajw1O2xsqKK2VRcz1JjwaH0d9G_602snooNUpBhdDegt_yGA@mail.gmail.com>
	<527B541D.5000101@giantdisaster.de>
	<CAMajw1MVmO5dbkDB7Wj1J-O0mTE-q6xyo1Do83gQk8RLX2dnpQ@mail.gmail.com>
Date: Thu, 7 Nov 2013 11:43:15 +0000
Message-ID: <CAMajw1O4-zrfxYgxeZaTNwtgY-_zTUpBbiLSExkcmwuyU5x+mw@mail.gmail.com>
Subject: Re: Fwd: unable to delete files after kernel upgrade from 3.8.10 to 3.12
From: Bartosz Kulicki <bartosz.kulicki@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FWIW - just before nuking the fs I have added a 3GB loopback device to btrfs.

This restored ability to delete the files but I could not remove the
loopback after deleting some large files (if I remember correctly
error I got was "block device required")

cheers,
Bart
