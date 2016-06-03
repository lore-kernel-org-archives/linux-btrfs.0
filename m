Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33339 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbcFCOLr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 10:11:47 -0400
Received: by mail-oi0-f66.google.com with SMTP id m198so17279946oig.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 07:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com> <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
From: Martin <rc6encrypted@gmail.com>
Date: Fri, 3 Jun 2016 16:11:45 +0200
Message-ID: <CAGQ70YdK0XZeDB_J7ugcQj-c=UPYimo=MUGPTNy8oOVpi8H9GA@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Make certain the kernel command timer value is greater than the driver
> error recovery timeout. The former is found in sysfs, per block
> device, the latter can be get and set with smartctl. Wrong
> configuration is common (it's actually the default) when using
> consumer drives, and inevitably leads to problems, even the loss of
> the entire array. It really is a terrible default.

Are nearline SAS drives considered consumer drives?
