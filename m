Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34757 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbeHURdi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:33:38 -0400
Received: by mail-io0-f174.google.com with SMTP id c22-v6so9372466iob.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 07:13:19 -0700 (PDT)
Subject: Re: Are the btrfs mount options inconsistent?
To: David Howells <dhowells@redhat.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, clm@fb.com, linux-btrfs@vger.kernel.org, wqu@suse.de
References: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
 <20180816130515.GR24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <32208.1534767847@warthog.procyon.org.uk>
 <341.1534859015@warthog.procyon.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5eb21737-9783-f774-5777-e8f759e9b7b6@gmail.com>
Date: Tue, 21 Aug 2018 10:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <341.1534859015@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-21 09:43, David Howells wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> 
>> But to be more clear, NOSSD shouldn't be a special case.
>> In fact currently NOSSD only affects whether we will output the message
>> "enabling ssd optimization", no real effect if I didn't miss anything.
> 
> That's not quite true.  In:
> 
> 	if (!btrfs_test_opt(fs_info, NOSSD) &&
> 	    !fs_info->fs_devices->rotating) {
> 		btrfs_set_and_info(fs_info, SSD, "enabling ssd optimizations");
> 	}
> 
> the call to btrfs_set_and_info() will turn on SSD.
> 
> What this seems to me is that, normally, SSD will be turned on automatically
> unless at least one of the devices is a rotating medium - but this appears to
> be explicitly suppressed by the NOSSD option.
That's my understanding too (though I may be wrong, I'm not an expert on C).

If this _isn't_ what's happening, then it needs to be changed so it is, 
that's what the documentation has pretty much always said, and is 
therefore how people expect it to work (also, it needs to work because 
there needs to be an option other than poking around at sysfs attributes 
to disable this on non-rotational media where it's not want4ed).
