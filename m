Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:60025 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaLRSfa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 13:35:30 -0500
Received: by mail-la0-f53.google.com with SMTP id gm9so1487947lab.26
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 10:35:28 -0800 (PST)
Received: from [10.0.0.163] ([31.99.148.180])
        by mx.google.com with ESMTPSA id tl8sm1989347lbb.47.2014.12.18.10.35.24
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 18 Dec 2014 10:35:26 -0800 (PST)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: btrfs-progs: integration-20141218 possible corruption test regression
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Date: Thu, 18 Dec 2014 18:35:16 +0000
To: linux-btrfs@vger.kernel.org
Message-ID: <4A7D957D-FE36-452D-B6DB-12117FF75AB9@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys, 

The latest integration fails 'make test' with the following output:

     [TEST]    013-leaf-corruption-no-extent-data.tar.xz
btrfs check should have detected corruption
Makefile:144: recipe for target 'test' failed
make: *** [test] Error 1
rm btrfs-corrupt-block.o


I've only built the progs on a single machine so far, but it consistently fails at this test. 

Cheers, 


WorMzy
