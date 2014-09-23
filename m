Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:49488 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbaIWOZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 10:25:17 -0400
Received: by mail-vc0-f171.google.com with SMTP id ij19so3795800vcb.30
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 07:25:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <542177BF.2000808@gmail.com>
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com>
 <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net> <54208BBC.1000700@xunil.at>
 <542162A8.2010700@gmail.com> <5421706F.6070301@xunil.at> <542177BF.2000808@gmail.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Tue, 23 Sep 2014 16:24:56 +0200
Message-ID: <CAGwxe4iqZY-GB3tREyqU0O4rkLk0_+oBdft1pRzaTxbZkr-JbQ@mail.gmail.com>
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If it is unknown, which of these options have been used at btrfs
creation time - is it possible to check the state of these options
afterwards on a mounted or unmounted filesystem?


2014-09-23 15:38 GMT+02:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
>
> Well, running 'mkfs.btrfs -O list-all' with 3.16 btrfs-progs gives the following list of features:
> mixed-bg                - mixed data and metadata block groups
> extref                  - increased hard-link limit per file to 65536
> raid56                  - raid56 extended format
> skinny-metadata         - reduced size metadata extent refs
> no-holes                - no explicit hole extents for files
