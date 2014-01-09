Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58034 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaAISAD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 13:00:03 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so3611065pad.40
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 10:00:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1A23203F-CC51-4D39-B868-0C4188357F08@colorremedies.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
	<20140109104247.GH15634@carfax.org.uk>
	<pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>
	<52CE9B9C.2040006@gmail.com>
	<pan$5a8b0$23680cbf$a1bd97e9$1743c66f@cox.net>
	<CAPpBBdNNHB3igMK67j5FpZxg7f6tmxGZk8x1OSwKd8GhTqsj=w@mail.gmail.com>
	<1A23203F-CC51-4D39-B868-0C4188357F08@colorremedies.com>
Date: Thu, 9 Jan 2014 19:00:03 +0100
Message-ID: <CAPpBBdONs6cg7xTkBxZuGTrLQRSeMzFrezBFC80maU52J1NS1g@mail.gmail.com>
Subject: Re: How does btrfs handle bad blocks in raid1?
From: George Eleftheriou <eleftg@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> How is a resilient 2 disk failure possible with four disk raid10?

   __________     ___ RAID0
__|__       __|__   ___ RAID1
 |     |        |     |
A    B      C    D

Loosing A+C / A+D / B+C / B+D  is resilient.
Loosing A+B or C+D is catastrophic.

Sorry, it's my fault. In my urge to praise Duncan's promotion of n-way
mirroring I created a misunderstanding.
