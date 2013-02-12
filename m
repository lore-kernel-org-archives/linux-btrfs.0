Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53346 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3BLSAi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 13:00:38 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so199813eek.40
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 10:00:37 -0800 (PST)
Message-ID: <511A837D.7090203@gmail.com>
Date: Tue, 12 Feb 2013 19:01:33 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Filipe Brandenburger <filbranden@google.com>
CC: dsterba@suse.cz, Ian Kumlien <pomac@demius.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
References: <1360283822-23452-1-git-send-email-pomac@demius.net> <1360283822-23452-3-git-send-email-pomac@demius.net> <20130212163938.GA12339@twin.jikos.cz> <CADU+-uBA3k3wW_tLDR4WvRt1EaitWcUNGXCzs6xhYJ_ExSmXkw@mail.gmail.com>
In-Reply-To: <CADU+-uBA3k3wW_tLDR4WvRt1EaitWcUNGXCzs6xhYJ_ExSmXkw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/2013 06:37 PM, Filipe Brandenburger wrote:
> Hi,
> 
> On Tue, Feb 12, 2013 at 8:39 AM, David Sterba <dsterba@suse.cz> wrote:
>> +# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
>> +btrfsck: btrfs
>> +       @echo "    [CP]     $@"
>> +       $(Q)cp btrfs btrfsck
>> +
> 
> I think the idea was that btrfsck becomes a link (either symbolic or
> hardlink works) to btrfs...
> 
> Maybe just replace cp with ln?

I agree with Filipe, or even a script is reasonable. So we have only one
binary to update, and we avoid the risk to have a version mismatch
between btrfsck and btrfs. This could lead to a different behaviour
when the user call btrfsck instead btrfs. Finally this could save some
bytes of space.

Anyway my opinion would be to left this kind to decision to the
distribution. We (as upstream) should only remove the old btrfsck and
issue an WARNING/REMARK in the release note to notify this change.
Unfortunately btrfsck is old; now we must provide an alternative file to
overwrite this binary in order to avoid the mismatch above when the user
is used to recompile the binary from the source.

BR
Goffredo
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
