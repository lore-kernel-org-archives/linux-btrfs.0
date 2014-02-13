Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:54084 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaBMUwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 15:52:09 -0500
Received: by mail-yh0-f46.google.com with SMTP id v1so10723407yhn.33
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 12:52:09 -0800 (PST)
Received: from vfr.localnet (adsl-98-88-120-40.asm.bellsouth.net. [98.88.120.40])
        by mx.google.com with ESMTPSA id 23sm9403856yhj.5.2014.02.13.12.45.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2014 12:45:09 -0800 (PST)
From: "Garry T. Williams" <gtwilliams@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Possible to wait for snapshot deletion?
Date: Thu, 13 Feb 2014 15:45:08 -0500
Message-ID: <4127554.quurJk0k5Q@vfr>
In-Reply-To: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2-13-14 20:02:43 Kai Krakow wrote:
> Is it technically possible to wait for a snapshot completely purged
> from disk? I imagine an option like "--wait" for btrfs delete
> subvolume.

This may be what you're looking for:

    http://www.spinics.net/lists/linux-btrfs/msg29833.html 

-- 
Garry T. Williams

