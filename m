Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ble59-2-81-56-123-40.fbx.proxad.net ([81.56.123.40]:33257 "EHLO
	jmuchemb.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbaE3Scu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 14:32:50 -0400
Message-ID: <5388CD3A.6090600@jmuchemb.eu>
Date: Fri, 30 May 2014 20:26:02 +0200
From: Julien Muchembled <jm@jmuchemb.eu>
MIME-Version: 1.0
To: Adam Buchbinder <abuchbinder@google.com>, linux-btrfs@vger.kernel.org
CC: dave@jikos.cz
Subject: Re: [PATCH] Add some simple end-to-end tests for btrfs-convert.
References: <1400692827-14606-1-git-send-email-abuchbinder@google.com>
In-Reply-To: <1400692827-14606-1-git-send-email-abuchbinder@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 05/21/14 19:20, Adam Buchbinder a écrit :
> +	# 256MB is the smallest acceptable btrfs image.
> +	dd if=/dev/zero of=$here/test.img bs=1024 count=$((256*1024)) \
> +		>> convert-tests-results.txt 2>&1 || _fail "dd failed"

What about using a sparse file to speed up the test and be nicer with the underlying storage ?
For example:
  truncate -s 256M $here/test.img

Because this does not reset test.img with zeros, one may want to the
  rm -f test.img
line at the beginning of the test function.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
