Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:48978 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdAaJPx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 04:15:53 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 939C49B85C
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 09:08:57 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 6AFD55FBB3
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 09:08:57 +0000 (GMT)
Subject: Re: btrfs recovery
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
 <014c7da2-0129-caee-00d8-12f2af628efc@mendix.com>
 <CAP8EXU310iKo-exrYk3Hm4tyUQSL+KYEYEV4h8zifiwxmse7uA@mail.gmail.com>
 <161bffef-9bc8-e5da-476b-d214e2a7d69b@aei.mpg.de>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <3c1bd063-13be-ce1c-6815-f9a5be7c4d4c@cobb.uk.net>
Date: Tue, 31 Jan 2017 09:08:56 +0000
MIME-Version: 1.0
In-Reply-To: <161bffef-9bc8-e5da-476b-d214e2a7d69b@aei.mpg.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30/01/17 22:37, Michael Born wrote:
> Also, I'm not interested in restoring the old Suse 13.2 system. I just
> want some configuration files from it.

If all you really want is to get some important information from some
specific config files, and it is so important it is worth an hour or so
of your time, you could consider a brute-force method such as just
grep-ing the whole image file for a string you know should appear in the
relevant config file and dumping the blocks around those locations to
see if you can see the data you need.

Unfortunately this won't work if you had file compression on. Or if
there is no reasonably unique text to search for, of course. Just a thought.

