Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:48493 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaHAL7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 07:59:42 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so4195996wes.34
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Aug 2014 04:59:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFChkqtVPBembgw859O3wNTv3VMGdHjoorSrtSWL30SVj3AaAw@mail.gmail.com>
References: <CAFChkqszfFU51qkr1CSNgv0VKNhr8U_jEDv0_BPaZZghLzKojA@mail.gmail.com>
 <CAFChkquCzoJP6fussqdKB0rU8eDOz7=D=V8Pcugewdo1TgnmxQ@mail.gmail.com>
 <CAFChkquw9YA8DeX43zBy9_V3UwNmAZiAHziFavGst5YwL9vMuQ@mail.gmail.com>
 <CAFChkquYG02RQKDDvY03OHDsEUsas54D7mz6jRna+5MyuUc7oQ@mail.gmail.com> <CAFChkqtVPBembgw859O3wNTv3VMGdHjoorSrtSWL30SVj3AaAw@mail.gmail.com>
From: Peter Waller <peter@scraperwiki.com>
Date: Fri, 1 Aug 2014 12:59:01 +0100
Message-ID: <CAFChkqt-1cpVhMRKvron6+nh2Vn01T8qfpx68Nzdfn5xHa2LSA@mail.gmail.com>
Subject: Re: Machine lockup due to btrfs-transaction on AWS EC2 Ubuntu 14.04
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've reproduced these issues on a single-core machine which doesn't
appear to become completely unresponsive after 12 hours of copying (as
the other machines are deadlocking after 5-10 minutes, perhaps?), but
it does use 100% SYS CPU with no IO traffic for the vast majority of
the time. (In fact, constantly?)

The filesystem was originally created on an Ubuntu Saucy 13.10 machine
(and therefore older kernel + older btrfs-tools) on a PV guest with a
non-SSD block device.

The newer current machine is a HVM guest and the data is now on an SSD.

Below is a link to the dstat output and dmesg which shows this (note
the sys column on the left and the IOPs column on the right). This was
taken whilst copying files of varying sizes from many directories to a
sibling in the same directory.

`dstat -tcdnymlr 5`, which shows high sys CPU but no IO traffic:
https://gist.github.com/pwaller/cb8d088ebceb2707d24b

INFO: task sync:5906 blocked for more than 120 seconds.
https://gist.github.com/pwaller/574a369ea4b65fe125b9#file-dmesg-log-L541

INFO: task btrfs-transacti:2531 blocked for more than 120 seconds.
https://gist.github.com/pwaller/574a369ea4b65fe125b9#file-dmesg-log-L1015

INFO: task btrfs-flush_del:16764 blocked for more than 120 seconds.
https://gist.github.com/pwaller/574a369ea4b65fe125b9#file-dmesg-log-L1041
