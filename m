Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36567 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbLXCiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 21:38:24 -0500
Received: by mail-ig0-f173.google.com with SMTP id ph11so92284111igc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 18:38:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$3b05a$667561e3$4f808486$449baaf4@cox.net>
References: <E1aBsGQ-0007zz-4V@rmm6prod02.runbox.com>
	<pan$3b05a$667561e3$4f808486$449baaf4@cox.net>
Date: Wed, 23 Dec 2015 19:38:23 -0700
Message-ID: <CAJCQCtR=ydFe0w4MUAS6CGZeOe3wMMmijOW=qptF20uDZaSMyA@mail.gmail.com>
Subject: Re: Raid 5/6 Stability
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a worthwhile distinction between stability of raid56 vs all
other profiles, and btrfs multiple device failure behavior. Right now
there's no monitoring or notification of failures to user space. In
fact Btrfs itself doesn't really understand device failures, a device
can spit out many read or write errors and Btrfs keeps trying to read
and write. So there's no equivalent to faultiness like with md/mdadm.
Therefore you'll have to figure out a way to monitor kernel messages,
maybe via a script that parses for btrfs messages and emails any such
messages ever 10m or whatever.

Chris Murphy.
