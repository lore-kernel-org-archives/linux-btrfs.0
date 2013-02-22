Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38503 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3BVRYr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 12:24:47 -0500
Received: by mail-ie0-f176.google.com with SMTP id k13so983303iea.35
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 09:24:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5127A6C0.6080104@alumni.calpoly.edu>
References: <5127A6C0.6080104@alumni.calpoly.edu>
Date: Fri, 22 Feb 2013 11:24:46 -0600
Message-ID: <CAE5mzvg5ejN6_vxnQYLV9n1HjZhYB4fj2WhDKezg+-eEfden6w@mail.gmail.com>
Subject: Re: copy on write misconception
From: cwillu <cwillu@cwillu.com>
To: Mike Power <dodtsair@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Then if I copied this file no blocks would be copied until they are written.
> Hence the two files would use the same blocks underneath. But specifically
> that copy would be fast.  Since it would only need to write some metadata.
> But when I copy the file:
> time cp 10G 10G2

cp without arguments still does a regular copy; btrfs does nothing to
de-duplicate writes.

"cp --reflink 10G 10G2" will give you the results you expect.
