Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:57942 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab3DWQtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 12:49:36 -0400
Content-Type: text/plain;
	charset=us-ascii
Subject: Re: [PATCH 0/2] btrfs-progs: standardize utility filenames and add default rules to Makefile
References: <517463E4.7040400@redhat.com> <20130423160930.GV16427@twin.jikos.cz>
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20130423160930.GV16427@twin.jikos.cz>
Message-Id: <A4CB3585-D6EC-4FB2-BD7B-8A844FE1C583@redhat.com>
Date: Tue, 23 Apr 2013 12:48:54 -0400 (EDT)
To: "dsterba@suse.cz" <dsterba@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Apr 23, 2013, at 11:09 AM, David Sterba <dsterba@suse.cz> wrote:

> On Sun, Apr 21, 2013 at 05:10:44PM -0500, Eric Sandeen wrote:
>> 2 patches here.
> 
> I see only
> 
> [PATCH 2/2] btrfs-progs: Add default rules to Makefile
> 
> in my mbox that's threaded under the 0/2 cover mail.
> 
I must have run into a size limit on the server... Let me double check on the rename behavior which should make it smaller, I think?

Eric


>> I think this is a net win, with a bit less Makefile code
>> duplication, but if people don't like it, no big deal.  I was hoping
>> to clean up & re-organize the userspace build a little, and this
>> seems like a decent first step along the way.
> 
> Looks ok to me, the rule duplication was obvious and asking for a
> cleanup.
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
