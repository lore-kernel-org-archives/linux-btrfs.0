Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0070.outbound.protection.outlook.com ([104.47.38.70]:15870
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751882AbdG1SUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 14:20:17 -0400
From: William Muriithi <william@perasotech.com>
To: Roman Mamedov <rm@romanrm.net>,
        "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Btrfs + compression = slow performance and high cpu usage
Date: Fri, 28 Jul 2017 18:20:14 +0000
Message-ID: <DM2PR08MB701E0AB9CC2DFEC6CB88C8DCEBF0@DM2PR08MB701.namprd08.prod.outlook.com>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
 <20170728224835.41c98aea@natsu>
In-Reply-To: <20170728224835.41c98aea@natsu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Roman,

> autodefrag

This sure sounded like a good thing to enable? on paper? right?...

The moment you see anything remotely weird about btrfs, this is the first thing you have to disable and retest without. Oh wait, the first would be qgroups, this one is second.

What's the problem with autodefrag?  I am also using it, so you caught my attention when you implied that it shouldn't be used.  According to docs, it seem like one of the very mature feature of the filesystem.  See below for the doc I am referring to 

https://btrfs.wiki.kernel.org/index.php/Status

I am using it as I assumed it could prevent the filesystem being too fragmented long term, but never thought there was price to pay for using it

Regards,
William

