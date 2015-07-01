Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f41.google.com ([209.85.216.41]:39142 "EHLO
	mail-vn0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbbGAPur (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 11:50:47 -0400
Received: by vnav203 with SMTP id v203so7135135vna.6
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 08:50:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
Date: Wed, 1 Jul 2015 09:50:46 -0600
Message-ID: <CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs version is 4.0, what is the kernel versions you've tried
to mount with?

I suggest running btrfs check (without --repair) and including the
full output. There are a lot of changes in btrfs-progs 4.1, but off
hand I don't know that they'd affect btrfs check results.


Chris Murphy
