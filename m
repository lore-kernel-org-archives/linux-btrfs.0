Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43646 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934594AbaEFKlZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 06:41:25 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so548524eek.6
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 03:41:23 -0700 (PDT)
Received: from [192.168.178.62] (port-92-200-103-129.dynamic.qsc.de. [92.200.103.129])
        by mx.google.com with ESMTPSA id m44sm11093358eeh.14.2014.05.06.03.41.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 06 May 2014 03:41:22 -0700 (PDT)
Message-ID: <5368BC62.2020701@googlemail.com>
Date: Tue, 06 May 2014 12:41:38 +0200
From: Hendrik Siedelmann <hendrik.siedelmann@googlemail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Btrfs raid allocator
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all!

I would like to use btrfs (or anyting else actually) to maximize raid0 
performance. Basically I have a relatively constant stream of data that 
simply has to be written out to disk. So my question is, how is the 
block allocator deciding on which device to write, can this decision be 
dynamic and could it incorporate timing/troughput decisions? I'm willing 
to write code, I just have no clue as to how this works right now. I 
read somewhere that the decision is based on free space, is this still true?

Cheers
Hendrik
