Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43053 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdDGASR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 20:18:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cwHbK-0006RR-6A
        for linux-btrfs@vger.kernel.org; Fri, 07 Apr 2017 02:18:06 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Do different btrfs volumes compete for CPU?
Date: Fri, 07 Apr 2017 01:17:59 +0100
Message-ID: <oc6lrh$k7k$1@blaine.gmane.org>
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru> <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net> <ef8ec943-6d26-d7e9-d4ac-05e2ce7a8532@rqc.ru> <22751.32343.177176.307907@tree.ty.sabi.co.uk> <07258eab-5a2a-f028-48fb-60906b689cfa@rqc.ru> <22755.55691.456250.585931@tree.ty.sabi.co.uk> <e4849b22-8311-f5f7-fa2e-2a56b1b78aa5@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <e4849b22-8311-f5f7-fa2e-2a56b1b78aa5@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/17 08:04, Marat Khalili wrote:
> On 04/04/17 20:36, Peter Grandi wrote:
>> SATA works for external use, eSATA works well, but what really
>> matters is the chipset of the adapter card.
> eSATA might be sound electrically, but mechanically it is awful. Try to
> run it for months in a crowded server room, and inevitably you'll get
> disconnections and data corruption. Tried different cables, brackets --
> same result. If you ever used eSATA connector, you'd feel it.

Been using eSATA here for multiple disk packs continuously connected for
a few years now for 48TB of data (not enough room in the host for the
disks).

Never suffered am eSATA disconnect.

Had the usual cooling fan fails and HDD fails due to old age.


All just a case of ensuring undisturbed clean cabling and a good UPS?...

(BTRFS spanning four disks per external pack has worked well also.)

Good luck,
Martin


