Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:39358 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbcBXQLm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 11:11:42 -0500
Subject: Re: [PATCH v2] Btrfs: fix listxattrs not listing all xattrs packed in
 the same item
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <1456163525-1098-1-git-send-email-fdmanana@kernel.org>
 <1456329239-30802-1-git-send-email-fdmanana@kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56CDD63B.70601@googlemail.com>
Date: Wed, 24 Feb 2016 17:11:39 +0100
MIME-Version: 1.0
In-Reply-To: <1456329239-30802-1-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/24/16 16:53, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In the listxattrs handler, we were not listing all the xattrs that are
> packed in the same btree item, which happens when multiple xattrs have
> a name that when crc32c hashed produce the same checksum value.
> 
> Fix this by processing them all.
(snip)
> V2: Fixed logic to jump into next item, which was detected by warnings
>     from gcc 5.3.0 (reported by Holger).

Great! No more warnings and also a lot less confusing. :)

thanks!
Holger

