Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030231Ab3FTTt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 15:49:56 -0400
Date: Thu, 20 Jun 2013 12:49:53 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 7/8] Btrfs: check UUID tree during mount if required
Message-ID: <20130620194953.GD32674@lenny.home.zabbo.net>
References: <cover.1371749051.git.sbehrens@giantdisaster.de>
 <a385ab71c448183b419e708cff4bd2473d53ca80.1371749051.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a385ab71c448183b419e708cff4bd2473d53ca80.1371749051.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +	key.objectid = 0;
> +	key.type = BTRFS_UUID_KEY;
> +	key.offset = 0;
> +
> +	max_key.objectid = (u64)-1;
> +	max_key.type = BTRFS_UUID_KEY;
> +	max_key.offset = (u64)-1;

> +		if (key.offset < (u64)-1) {
> +			key.offset++;
> +		} else if (key.type < BTRFS_UUID_KEY) {
> +			key.offset = 0;
> +			key.type = BTRFS_UUID_KEY;
> +		} else if (key.objectid < (u64)-1) {
> +			key.offset = 0;
> +			key.type = 0;
> +			key.objectid++;
> +		} else {
> +			break;
> +		}
> +	}

Presumably all of this isn't needed now that the uuid items are in their
own tree?  Just iterate over all the items in the tree?

- z
