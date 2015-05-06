Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38174 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbbEFRZw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 13:25:52 -0400
Received: by igbhj9 with SMTP id hj9so23030805igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 10:25:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$a2a67$3e7e2090$a73a1a0d$778571d0@cox.net>
References: <4306bc25fe19b7dd623c8e724292d7bb@admin.virtall.com>
	<1409745869.21602.21.camel@localhost>
	<20140824000720.GN3875@merlins.org>
	<20140926214821.GX13219@merlins.org>
	<20150502141102.GB1809@merlins.org>
	<20150501210013.GH13624@merlins.org>
	<20150429232130.GA23814@merlins.org>
	<20150502163010.GK13624@merlins.org>
	<20150505063215.GA28387@merlins.org>
	<20150505195610.GE23216@merlins.org>
	<20150505210209.GG23216@merlins.org>
	<pan$a2a67$3e7e2090$a73a1a0d$778571d0@cox.net>
Date: Wed, 6 May 2015 11:25:51 -0600
Message-ID: <CAJCQCtT2YSfWQWmETiOzv4z0pJFnNP2fNXnu+ZZtVyOHurr90A@mail.gmail.com>
Subject: Re: 3.19.6: __btrfs_free_extent:5987: errno=-2 No such entry, did
 btrfs check --repair break it?
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 6, 2015 at 5:04 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> Long story short, nothing I tried (mounting with recovery, the new
> integrated btrfs rescue zero-log, btrfs check --repair...)

What is integrated btrfs rescue zero-log btrfs check? Where is it? I
don't see a check or repair option in btrfs rescue, I do see zero-log
(and chunk-recover and super-recover).

> So I got to use the new btrfs-progs v4.0 metadata-restoration
> option in btrfs restore,

In man btrfs-restore I only see a -m option, is that what you're referring to?

-- 
Chris Murphy
