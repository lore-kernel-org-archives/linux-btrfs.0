Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:50473 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaIHQwe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 12:52:34 -0400
Message-ID: <540DE05E.1030405@inwind.it>
Date: Mon, 08 Sep 2014 18:59:10 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Chris Mason <clm@fb.com>, Miao Xie <miaox@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Scan all devices to build fs device list
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com> <540B6900.7000307@fb.com> <20140908090946.GI5636@twin.jikos.cz>
In-Reply-To: <20140908090946.GI5636@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 09/08/2014 11:09 AM, David Sterba wrote:
> Automatic scanning in usperspace can be done via the mount helper and
> this is IMO the way to go. There's a patch for that from Goffredo, not
> merged yet, the patch backlog is still too long.

There is something that I can do to help you regarding this patch ?


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
