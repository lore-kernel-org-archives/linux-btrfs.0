Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36107 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbcHGTPm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Aug 2016 15:15:42 -0400
Received: by mail-oi0-f43.google.com with SMTP id f189so149124912oig.3
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Aug 2016 12:15:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPT_Aj+gzL6Pnz4JeN2Aco_Enq__3Pd=qYnC4M8=b-8Q=UPTmA@mail.gmail.com>
References: <CAPT_Aj+gzL6Pnz4JeN2Aco_Enq__3Pd=qYnC4M8=b-8Q=UPTmA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 7 Aug 2016 13:15:40 -0600
Message-ID: <CAJCQCtSbrEy-e6+q79NFxkjpyGQqMiY_gDa3vnZdUjUjCCSBjg@mail.gmail.com>
Subject: Re: Unmountable and unrepairable BTRFS
To: Chris McFaul <mcfaul@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs check link appears to be stale, no btrfs check.

find root seems promising
Well block 72701214523392(gen: 56072 level: 1) seems good, but
generation/level doesn't match, want gen: 56073 level: 1

Those are quite close, so what I'd say off hand is that mounting -o
usebackuproot should help.


Chris Murphy
