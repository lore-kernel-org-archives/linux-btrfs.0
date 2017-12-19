Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:41356 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753258AbdLSThB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 14:37:01 -0500
Received: by mail-pg0-f68.google.com with SMTP id o2so10946856pgc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 11:37:01 -0800 (PST)
Date: Tue, 19 Dec 2017 11:36:58 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
Message-ID: <20171219193658.GA22017@vader.DHCP.thefacebook.com>
References: <20171219104511.3563-1-wqu@suse.com>
 <20171219190125.GA19899@vader.DHCP.thefacebook.com>
 <b6545013-8f09-d88b-20f4-df3ee9d4f39e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6545013-8f09-d88b-20f4-df3ee9d4f39e@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 09:19:10PM +0200, Nikolay Borisov wrote:
> 
> 
> On 19.12.2017 21:01, Omar Sandoval wrote:
> > My only objection is that we shouldn't rename the field names in the
> > UAPI header. Let's just add a comment that the two counters are ignored.
> > Besides that,
> 
> Why is that?

We don't know if anyone is including the UAPI header and referring to
these fields for whatever reason. A quick Google search doesn't turn up
anything, but it has been there forever so I think we should err on the
side of not breaking the API.
