Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35114 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbcLHUlh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 15:41:37 -0500
Received: by mail-yw0-f194.google.com with SMTP id b66so35561416ywh.2
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 12:41:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
References: <1481222198.6563.3.camel@scientia.net> <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 8 Dec 2016 13:41:36 -0700
Message-ID: <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
Subject: Re: out-of-band dedup status?
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pretty sure it will not dedupe extents that are referenced in a read
only subvolume.


Chris Murphy
