Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50077 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbaFRU5R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 16:57:17 -0400
Received: by mail-oa0-f41.google.com with SMTP id l6so3214556oag.28
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 13:57:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Jun 2014 16:57:16 -0400
Message-ID: <CAB9dFdsyB40V2BGwdQKzSSz7YUWMh-C2AWdDNK=PMG9h+BO57w@mail.gmail.com>
Subject: Lockups with btrfs on 3.16-rc1 - bisected
From: Marc Dionne <marc.c.dionne@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Waiman.Long@hp.com, t-itoh@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been seeing very reproducible soft lockups with 3.16-rc1 similar
to what is reported here:
http://marc.info/?l=linux-btrfs&m=140290088532203&w=2 , along with the
occasional hard lockup, making it impossible to complete a parallel
build on a btrfs filesystem for the package I work on.  This was
working fine just a few days before rc1.

Bisecting brought me to the following commit:

  commit bd01ec1a13f9a327950c8e3080096446c7804753
  Author: Waiman Long <Waiman.Long@hp.com>
  Date:   Mon Feb 3 13:18:57 2014 +0100

      x86, locking/rwlocks: Enable qrwlocks on x86

And sure enough if I revert that commit on top of current mainline,
I'm unable to reproduce the soft lockups and hangs.

Marc
