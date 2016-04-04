Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49566 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbcDDQUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 12:20:55 -0400
Subject: Re: [PATCH] delete obsolete function btrfs_print_tree()
To: fdmanana@gmail.com
References: <56F550DD.1030200@googlemail.com>
 <20160404135641.GB3412@twin.jikos.cz> <57028E42.1090901@googlemail.com>
 <CAL3q7H5XDU2sNEVmYYsc7L72zCbN7Dpdx-nsSETwdJQd529z0A@mail.gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <57029465.7020904@googlemail.com>
Date: Mon, 4 Apr 2016 18:20:53 +0200
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5XDU2sNEVmYYsc7L72zCbN7Dpdx-nsSETwdJQd529z0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/16 18:02, Filipe Manana wrote:
> I use this function frequently during development, and there's a good
> reason to use it instead of the user space tool btrfs-debug-tree.

Good to know, that's why I asked. Printing unwritten extents makes sense.

-h

