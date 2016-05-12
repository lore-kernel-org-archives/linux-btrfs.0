Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34318 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbcELGte (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 02:49:34 -0400
Received: by mail-oi0-f65.google.com with SMTP id d139so10930726oig.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 May 2016 23:49:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
Date: Thu, 12 May 2016 00:49:33 -0600
Message-ID: <CAJCQCtQAz1h=7ObUgpQNWY7V=9nM+z7_Y5ZgeiM=a_EfyT3jMg@mail.gmail.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: Chris Murphy <lists@colorremedies.com>
To: Richard Lochner <lochner@clone1.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What are the mount options for this filesystem?

Maybe filter with grep/egrep the journalctl output or
/var/log/messages for -i btrfs, and also for libata/scsi messages.
Anything over previous days might reveal some clue.

I've got multiple Btrfs raid1's and several times I've had
*correctable* errors. So your expectation is proper.


Chris Murphy
