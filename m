Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:41649 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbeCJO3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 09:29:16 -0500
Message-ID: <1520692153.24363.15.camel@scientia.net>
Subject: Re: Ongoing Btrfs stability issues
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Nikolay Borisov <nborisov@suse.com>, Alex Adriaanse <alex@oseberg.io>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 10 Mar 2018 15:29:13 +0100
In-Reply-To: <5a12a7b7-6cf3-82f8-d5fa-2915fc3d6680@suse.com>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
         <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
         <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
         <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
         <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
         <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
         <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
         <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
         <5a12a7b7-6cf3-82f8-d5fa-2915fc3d6680@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2018-03-10 at 14:04 +0200, Nikolay Borisov wrote:
> So for OLTP workloads you definitely want nodatacow enabled, bear in
> mind this also disables crc checksumming, but your db engine should
> already have such functionality implemented in it.

Unlike repeated claims made here on the list and other places... I
woudln't now *any* DB system which actually does this per default and
or in a way that would be comparable to filesystem lvl checksumming.


Look back in the archives... when I've asked several times for
checksumming support *with* nodatacow, I evaluated the existing status
for the big ones (postgres,mysql,sqlite,bdb)... and all of them had
this either not enabled per default, not at all, or requiring special
support for the program using the DB.


Similar btw: no single VM image type I've evaluated back then had any
form of checksumming integrated.


Still, one of the major deficiencies (not in comparison to other fs,
but in comparison to how it should be) of btrfs unfortunately :-(


Cheers,
Chris.
