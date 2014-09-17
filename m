Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.bordeaux.inra.fr ([147.100.111.220]:64182 "EHLO
	mail-1.bordeaux.inra.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754377AbaIQJGS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 05:06:18 -0400
Received: from [147.100.98.136] ([147.100.98.136])
	(authenticated bits=0)
	by mail-1.bordeaux.inra.fr (/8.14.4) with ESMTP id s8H9BtwE008719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 11:11:55 +0200 (CEST)
Message-ID: <54194F07.2080203@bordeaux.inra.fr>
Date: Wed, 17 Sep 2014 11:06:15 +0200
From: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Problem with a filesystem
References: <54185D48.5060701@bordeaux.inra.fr> <4F2E9AE1-4B33-42BB-8B75-C5A66118A7CB@colorremedies.com> <5418995C.2000708@bordeaux.inra.fr> <82857E4F-9FF6-4110-993F-35830A44BC04@colorremedies.com>
In-Reply-To: <82857E4F-9FF6-4110-993F-35830A44BC04@colorremedies.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2014 11:27 PM, Chris Murphy wrote:
> 
> Try to mount normally, then with -o recovery, then with -o ro,recovery. Include dmesg showing any messages that appear for these attempts.
Thank you,
Please find below the messages shown during a normal mount and a mount
with -o ro,recovery.

======== Normal Mount ========
/var/log/messages
Sep 17 11:00:24 sdeeph1 kernel: [85051.529541] device fsid
9ddd403a-2863-4e71-b28d-d2931a133af3 devid 1 transid 255446 /dev/sda4
Sep 17 11:00:24 sdeeph1 kernel: [85051.529917] btrfs: disk space caching
is enabled
Sep 17 11:01:09 sdeeph1 kernel: [85096.286741] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:01:09 sdeeph1 kernel: [85096.286756] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:01:09 sdeeph1 kernel: [85096.286764] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:01:09 sdeeph1 kernel: [85096.286770] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:01:09 sdeeph1 kernel: [85096.286775] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:01:09 sdeeph1 kernel: [85096.408271] btrfs: open_ctree failed

/var/log/syslog adds this line :
Sep 17 11:01:09 sdeeph1 kernel: [85096.286782] Failed to read block
groups: -5


======== mount -o ro,recovery ========
/var/log/messages
Sep 17 11:05:10 sdeeph1 kernel: [85337.307267] device fsid
9ddd403a-2863-4e71-b28d-d2931a133af3 devid 1 transid 255446 /dev/sda4
Sep 17 11:05:10 sdeeph1 kernel: [85337.307635] btrfs: enabling auto recovery
Sep 17 11:05:10 sdeeph1 kernel: [85337.307639] btrfs: disk space caching
is enabled
Sep 17 11:05:55 sdeeph1 kernel: [85381.548215] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:05:55 sdeeph1 kernel: [85381.548229] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:05:55 sdeeph1 kernel: [85381.548237] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:05:55 sdeeph1 kernel: [85381.548243] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:05:55 sdeeph1 kernel: [85381.548249] parent transid verify
failed on 24562568384512 wanted 255444 found 255446
Sep 17 11:05:55 sdeeph1 kernel: [85381.670344] btrfs: open_ctree failed

/var/log/syslog adds this line :
Sep 17 11:05:55 sdeeph1 kernel: [85381.548255] Failed to read block
groups: -5

