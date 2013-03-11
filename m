Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3CKTCx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 15:02:53 -0400
Date: Mon, 11 Mar 2013 12:02:09 -0700
From: Zach Brown <zab@redhat.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: clean up transaction abort messages
Message-ID: <20130311190209.GP3565@lenny.home.zabbo.net>
References: <1363021720-15684-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363021720-15684-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> * print the exact negative errno from btrfs_decode_error and
>   don't expect a simple snprintf to fail

What an.. odd function.  Looks like it was inherited from ext*.  And the
callers over in that neck of the woods also don't check for the
implemented-but-basically-impossible snprintf failure that leads to
returning null.

> +		snprintf(nbuf, 16, "error %d", errno);

The buffer is only used to print the error number for unknown errors?

If changing this function anyway, maybe you can find a few minutes to:

 - drop the nbuf arugment
 - just return static strings for known errnos
 - return "unknown" for unknown errors
 - and have the callers always print the string and error
   ": %s (errno %d)"

No worries if you're not keen to fix it up, but it'd be nice.  One less
wart to be distracted by when stumbling through the code.

- z
