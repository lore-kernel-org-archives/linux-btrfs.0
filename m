Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:54750 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2EYX2R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 19:28:17 -0400
Date: Fri, 25 May 2012 19:28:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <chris.mason@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fixup module.h usage as required
Message-ID: <20120525232811.GA31497@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This fairly trivial patch missed the 3.4 merge window:

http://lkml.indiana.edu/hypermail/linux/kernel/1202.3/00764.html

Do you have it queued for the 3.5 merge window now in play, or
would you rather I push the changeset myself directly?

Thanks,
Paul.
