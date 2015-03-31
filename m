Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36041 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbbCaMcS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 08:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <1427211349-8621-1-git-send-email-tomvanbraeckel@gmail.com>
References: <20150324140155.GU20767@twin.jikos.cz> <1427211349-8621-1-git-send-email-tomvanbraeckel@gmail.com>
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Date: Tue, 31 Mar 2015 14:31:37 +0200
Message-ID: <CAJ7vePA5CpzVSPwHD6X4arLPRLt9tdgXSVAcQtyugJporJG-ng@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: explicitly set control file's private_data
To: Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Van Braeckel <tomvanbraeckel@gmail.com>,
        Martin Kepplinger <martink@posteo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Err, upon further inspection, I think that this was a false positive.

Btrfs relies on the initial value of the private_data member of a file
being NULL in the regular ioctl operation handler for
BTRFS_IOC_TRANS_START but it does not use the miscdevice framework for
those files.

It *does* use the miscdevice framework in the ioctl operation handler
of the /dev/btrfs-control file but there it does not use the file's
private_data member. So IMHO, the proposed patch is not necessary...
