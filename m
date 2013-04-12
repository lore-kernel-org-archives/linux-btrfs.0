Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3DLQc5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 12:32:57 -0400
Date: Fri, 12 Apr 2013 18:32:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Shripad Ratnaparkhi <shripad.ratnaparkhi@gmail.com>
Cc: Harald Glatt <mail@hachre.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] btrfs.fsck failing to fix corrupted block
Message-ID: <20130412163255.GB18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CANu+oN1szXCzLDqeT8UMCz660dO47dDTa8PTL1KFUoG6z-u_rQ@mail.gmail.com>
 <CANu+oN1q-r2ti+uZs2_2Mg4_4J8gdNdtLedPAC3u5WZa=+jjFA@mail.gmail.com>
 <CAFWF=am8-swZ7-uBr4KQmHYHvwAfpKBwrudFu_LqgUEARWYE3A@mail.gmail.com>
 <CANu+oN3bfDfkzZ32y=fPu6s=xJOaPJc_F2we517kBNqXvd2o7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANu+oN3bfDfkzZ32y=fPu6s=xJOaPJc_F2we517kBNqXvd2o7A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 07, 2013 at 07:41:04AM +0530, Shripad Ratnaparkhi wrote:
> Yup, that is exactly the case.
> I got to know about no support of fsck.btrfs at boot up, so symlinked
> btrfsck and built the initrd.

https://btrfs.wiki.kernel.org/index.php/FAQ#What.27s_the_difference_between_btrfsck_and_fsck.btrfs

btrfsck is not supposed to be run at boot time, therefore fsck.btrfs is
only a stub.

david
