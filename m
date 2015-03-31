Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:35142 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbbCaNkt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 09:40:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 31 Mar 2015 15:40:46 +0200
From: Martin Kepplinger <martink@posteo.de>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: explicitly set control file's
 =?UTF-8?Q?private=5Fdata?=
In-Reply-To: <CAJ7vePA5CpzVSPwHD6X4arLPRLt9tdgXSVAcQtyugJporJG-ng@mail.gmail.com>
References: <20150324140155.GU20767@twin.jikos.cz>
 <1427211349-8621-1-git-send-email-tomvanbraeckel@gmail.com>
 <CAJ7vePA5CpzVSPwHD6X4arLPRLt9tdgXSVAcQtyugJporJG-ng@mail.gmail.com>
Message-ID: <c856fb189db91b156581f26e673e5cf9@posteo.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 31.03.2015 14:31 schrieb Tom Van Braeckel:
> Err, upon further inspection, I think that this was a false positive.
> 
> Btrfs relies on the initial value of the private_data member of a file
> being NULL in the regular ioctl operation handler for
> BTRFS_IOC_TRANS_START but it does not use the miscdevice framework for
> those files.
> 
> It *does* use the miscdevice framework in the ioctl operation handler
> of the /dev/btrfs-control file but there it does not use the file's
> private_data member. So IMHO, the proposed patch is not necessary...

This is offtopic, assuming you are right and didn't find more affected 
places:

Then I would say you could re-post the real change (to misc_open() ) to 
the
relevant people for 4.2 (not 4.1), so either wait for 4.0 to be released 
or try
something like "for 4.2" in the topic (or as a comment after the --- 
dashes in
the patch email)

I would want to have it in -next for one cycle at least.

Further, I would remove the code-comment you had here
https://lkml.org/lkml/2015/1/9/718 because GregKH already pulled this in
(a little too early ;) :
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=03190c67ff72b5c56b24266762ab8abe68970f45
which is extractable kernel documenation. You could somehow link to it
in the commit message.

                                   martin
