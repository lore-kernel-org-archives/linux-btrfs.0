Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:35122 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaHEKX4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 06:23:56 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so751436wes.30
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 03:23:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFChkqt-1cpVhMRKvron6+nh2Vn01T8qfpx68Nzdfn5xHa2LSA@mail.gmail.com>
References: <CAFChkqszfFU51qkr1CSNgv0VKNhr8U_jEDv0_BPaZZghLzKojA@mail.gmail.com>
 <CAFChkquCzoJP6fussqdKB0rU8eDOz7=D=V8Pcugewdo1TgnmxQ@mail.gmail.com>
 <CAFChkquw9YA8DeX43zBy9_V3UwNmAZiAHziFavGst5YwL9vMuQ@mail.gmail.com>
 <CAFChkquYG02RQKDDvY03OHDsEUsas54D7mz6jRna+5MyuUc7oQ@mail.gmail.com>
 <CAFChkqtVPBembgw859O3wNTv3VMGdHjoorSrtSWL30SVj3AaAw@mail.gmail.com> <CAFChkqt-1cpVhMRKvron6+nh2Vn01T8qfpx68Nzdfn5xHa2LSA@mail.gmail.com>
From: Peter Waller <peter@scraperwiki.com>
Date: Tue, 5 Aug 2014 11:23:14 +0100
Message-ID: <CAFChkqvyP2v1ueSH_9jSafArVbU2XMXNFxr1gqiXLMRm_DjX3Q@mail.gmail.com>
Subject: Re: Machine lockup due to btrfs-transaction on AWS EC2 Ubuntu 14.04
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My current interpretation of this problem is that it is some
pathological condition caused by not rebalancing and being nearly out
of space for allocating more metadata and hence it is rarely being
seen by anyone else (because most users are regularly doing
rebalances).

See this thread for details about rebalancing and out of space:
"ENOSPC with mkdir and rename" on 2014-08-02:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/37415

I haven't had the lockups now since July and I'm now trialling a
nightly rebalance:

$ btrfs filesystem balance start -dusage=50 -musage=10 "$mount"

I'll report back if I encounter further problems.
