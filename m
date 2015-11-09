Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbbKIOM6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Nov 2015 09:12:58 -0500
Date: Mon, 9 Nov 2015 15:12:56 +0100
From: Karel Zak <kzak@redhat.com>
To: Florian Margaine <florian.margaine@commerceguys.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix partitioned loop devices resolve.
Message-ID: <20151109141256.GW19508@ws.net.home>
References: <56409A52.2000708@commerceguys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56409A52.2000708@commerceguys.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 09, 2015 at 02:06:26PM +0100, Florian Margaine wrote:
> Instead of using string functions to extract the device name and reading
> this file, this patch uses the loop device API through ioctl to get the
> correct backing file.

    #define LO_NAME_SIZE    64

    struct loop_info64 {
        ...
        uint8_t         lo_file_name[LO_NAME_SIZE];
    };


The loopdev is based on file descriptor, the lo_file_name[] is hint
only and it does not have to match with the real path and the most
important problem is that it uses 64-bytes buffer.

For losetup we use LOOP_GET_STATUS64 ioctl as fallback solution only.

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
