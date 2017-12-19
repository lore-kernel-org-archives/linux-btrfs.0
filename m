Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43987 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752311AbdLSTTM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 14:19:12 -0500
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
To: Omar Sandoval <osandov@osandov.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20171219104511.3563-1-wqu@suse.com>
 <20171219190125.GA19899@vader.DHCP.thefacebook.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b6545013-8f09-d88b-20f4-df3ee9d4f39e@suse.com>
Date: Tue, 19 Dec 2017 21:19:10 +0200
MIME-Version: 1.0
In-Reply-To: <20171219190125.GA19899@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.12.2017 21:01, Omar Sandoval wrote:
> My only objection is that we shouldn't rename the field names in the
> UAPI header. Let's just add a comment that the two counters are ignored.
> Besides that,

Why is that?
