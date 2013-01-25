Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:37109 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3AYNwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 08:52:44 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
Date: Sat, 26 Jan 2013 00:52:31 +1100
Cc: Gene Czarcinski <gene@czarc.net>, linux-btrfs@vger.kernel.org
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <20130125175530.75402fb5@natsu>
In-Reply-To: <20130125175530.75402fb5@natsu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201301260052.31964.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Jan 2013, Roman Mamedov <rm@romanrm.ru> wrote:
> The user does not have to be root, they can be a member of the group "disk"
> to manage this device.
> 
> Also some or all of the tools accept not just a block device, but also a
> regular file as their parameter.
> 
> Wouldn't it be better to check whether or not the running user has
> write access to the device or file to be operated on, before failing?

Also UID==0 doesn't necessarily mean ultimate access to the system.  The case 
where the process is running as root but still lacks the access to perform the 
operations in question should also be handled.

Yes, ability to read/write the device/file or whatever is being operated on 
should be the criteria that is used not UID etc.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
