Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36388 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbGNVpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 17:45:33 -0400
Received: by pachj5 with SMTP id hj5so11815079pac.3
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 14:45:33 -0700 (PDT)
Received: from sharpeth.aviatis.com (c-107-3-142-14.hsd1.ca.comcast.net. [107.3.142.14])
        by smtp.gmail.com with ESMTPSA id uz9sm2343229pac.34.2015.07.14.14.45.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 14 Jul 2015 14:45:32 -0700 (PDT)
From: Johannes Ernst <johannes.ernst@gmail.com>
Content-Type: text/plain; charset=utf-8
Subject: 'btrfs subvolume list /' executed as non-root produces a not-so-nice error message
Message-Id: <234F8FC6-16F7-45A1-8F72-2355A9AC71B0@gmail.com>
Date: Tue, 14 Jul 2015 14:45:31 -0700
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ btrfs subvolume list /
ERROR: can't perform the search - Operation not permitted
ERROR: can't get rootid for ‘/'

I don't know what a 'rootid' is as a user, and i don't really want to ponder whether I need to find out.

What about a simple
ERROR: Permission denied.
instead?

Cheers,



Johannes.

