Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:17163 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab3GaQpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 12:45:53 -0400
Message-ID: <51F93F3E.9060108@giantdisaster.de>
Date: Wed, 31 Jul 2013 18:45:50 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v5 2/5] Btrfs: improve the delayed refs process in
 rm case
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com> <1375285066-14173-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375285066-14173-3-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Jul 2013 23:37:42 +0800, Liu Bo wrote:
> +	WARN_ON(update->ref_mod > 0 && update->ref_mod != 1);

WARN_ON(update->ref_mod > 1)

