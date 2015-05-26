Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37701 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbEZQ0x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 12:26:53 -0400
Received: by igbsb11 with SMTP id sb11so57596685igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 09:26:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150526142607.GE16826@carfax.org.uk>
References: <loom.20150526T103943-385@post.gmane.org>
	<20150526085246.GC16826@carfax.org.uk>
	<loom.20150526T112326-642@post.gmane.org>
	<20150526142607.GE16826@carfax.org.uk>
Date: Tue, 26 May 2015 10:26:53 -0600
Message-ID: <CAJCQCtR1EtjrXfH3TjtjiMwULTD9ZJ9VMfVHpTmyaM4gQr7fig@mail.gmail.com>
Subject: Re: btrfs on disk stability
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not really understanding the use case. Is this for one time copy
of a Btrfs file system or a need to keep the copies in sync? Because
this sounds like a better fit for rsync, btrfs send/receive, or drdb.

The part especially where I'm getting confused is where you say "start
copying blocks of sda to sdc" and yet you refer to "file handler" and
"mounting the new copy". I can't really tell if this is strictly a
block copy e.g. using dd, or if you're using cp/rsync -a or what. And
then, why do you need to mount the copy?

Chris Murphy
