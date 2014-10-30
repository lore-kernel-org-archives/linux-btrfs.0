Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([85.248.156.6]:39361 "EHLO
	shiva.plaintext.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaJ3Jba (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 05:31:30 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by shiva.plaintext.sk (Postfix) with ESMTP id 77A8526D59
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 10:26:08 +0100 (CET)
Received: from shiva.plaintext.sk ([127.0.0.1])
	by localhost (shiva.plaintext.sk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lSEWCUyRh7w7 for <linux-btrfs@vger.kernel.org>;
	Thu, 30 Oct 2014 10:26:07 +0100 (CET)
Received: from shiva.plaintext.sk (shiva.plaintext.sk [85.248.156.6])
	by shiva.plaintext.sk (Postfix) with ESMTP id B2A9726D20
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 10:26:07 +0100 (CET)
Date: Thu, 30 Oct 2014 10:26:07 +0100 (GMT+01:00)
From: luvar@plaintext.sk
To: linux-btrfs@vger.kernel.org
Message-ID: <650272300.271414661167523.JavaMail.root@shiva>
In-Reply-To: <1589590871.231414660858286.JavaMail.root@shiva>
Subject: btrfs deduplication and linux cache management
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I want to ask, if deduplicated file content will be cached in linux kernel just once for two deduplicated files.

To explain in deep:
 - I use btrfs for whole system with few subvolumes with some compression on some subvolumes.
 - I have two directories with eclipse SDK with slightly differences (same version, different config)
 - I assume that given directories is deduplicated and so two eclipse installations take place on hdd like one would (in rough estimation)
 - I will start one of given eclipse
 - linux kernel will cache all opened files during start of eclipse (I have enough free ram)
 - I am just happy stupid linux user:
    1. will kernel cache file content after decompression? (I think yes)
    2. cached data will be in VFS layer or in block device layer?
 - When I will lunch second eclipse (different from first, but deduplicated from first) after first one:
    1. will second start require less data to be read from HDD?
    2. will be metadata for second instance read from hdd? (I asume yes)
    3. will be actual data read second time? (I hope not)

Thanks for answers,
have a nice day,
--
LuVar
