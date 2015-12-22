Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33990 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbbLVX4t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 18:56:49 -0500
Received: by mail-ob0-f171.google.com with SMTP id iw8so154708377obc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 15:56:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
 <CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Tue, 22 Dec 2015 17:56:29 -0600
Message-ID: <CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
Subject: Re: Loss of connection to Half of the drives
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave S <bigdave.schulz@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Also understand with Brfs RAID 10 you can't lose more than 1 drive
> reliably. It's not like a strict raid1+0 where you can lose all of the
> "copy 1" *OR* "copy 2" mirrors.

Pardon my pea brain but this sounds like a pretty bad design flaw?
