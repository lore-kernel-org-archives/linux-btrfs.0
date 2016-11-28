Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:36833 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754175AbcK1LLx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 06:11:53 -0500
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: mount option nodatacow for VMs on =?iso-8859-1?Q?SSD=3F?=
Date: Mon, 28 Nov 2016 12:11:49 +0100
MIME-Version: 1.0
Message-ID: <ca646391-bd9f-49b2-bca4-8faee04fd82a@linuxsystems.it>
In-Reply-To: <20161128092015.70b75dd8@jupiter.sol.kaishome.de>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
 <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
 <20161128003829.GD15348@rus.uni-stuttgart.de>
 <20161128092015.70b75dd8@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On lunedì 28 novembre 2016 09:20:15 CET, Kai Krakow wrote:
> You can, however, use chattr to make the subvolume root directory (that
> one where it is mounted) nodatacow (chattr +C) _before_ placing any
> files or directories in there. That way, newly created files and
> directories will inherit the flag. Take note that this flag can only
> applied to directories and empty (zero-sized) files.

Do I keep checksumming for this directory such a way?

Niccolò Belli
