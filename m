Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53950 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932242AbdLTGuO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 01:50:14 -0500
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
To: Omar Sandoval <osandov@osandov.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20171219104511.3563-1-wqu@suse.com>
 <20171219190125.GA19899@vader.DHCP.thefacebook.com>
 <b6545013-8f09-d88b-20f4-df3ee9d4f39e@suse.com>
 <20171219193658.GA22017@vader.DHCP.thefacebook.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f2c5c069-2daa-3ed9-490a-88fb487c4b80@suse.com>
Date: Wed, 20 Dec 2017 08:50:11 +0200
MIME-Version: 1.0
In-Reply-To: <20171219193658.GA22017@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.12.2017 21:36, Omar Sandoval wrote:
> On Tue, Dec 19, 2017 at 09:19:10PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 19.12.2017 21:01, Omar Sandoval wrote:
>>> My only objection is that we shouldn't rename the field names in the
>>> UAPI header. Let's just add a comment that the two counters are ignored.
>>> Besides that,
>>
>> Why is that?
> 
> We don't know if anyone is including the UAPI header and referring to
> these fields for whatever reason. A quick Google search doesn't turn up
> anything, but it has been there forever so I think we should err on the
> side of not breaking the API.

So it makes sense, but I think we can be brave in this case and really
obscure them. Since from where I'm standing it looks someone made a
_really_ bad decision in making this debug aid part of the on-disk
format and now we have to live with that decision for eternity. I think
teh fact this was not documented provides enough safety for allowing us
to rename the members.

What if in the future we'd like to repurpose those values and use them
for something else it would make sense to rename an unused member to
something meaningful. "I know we have the don't break userspace" rule
but in this case I'm more inclined to disregard for the sake of
long-term maintainability. In the end it's not _that_ big of an issue so
I won't be anal about it but I really hate the situation we find
ourselves in - shit is merged and subsequently we can't really fix it ...


