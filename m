Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755419AbdKORDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:03:53 -0500
Date: Wed, 15 Nov 2017 18:01:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: let variable required be declared inside the
 loop
Message-ID: <20171115170158.GV28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171109154526.23181-1-anand.jain@oracle.com>
 <20171109154526.23181-3-anand.jain@oracle.com>
 <a387f7e4-19cb-26be-f9c5-4cd2458cf555@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a387f7e4-19cb-26be-f9c5-4cd2458cf555@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 09, 2017 at 05:53:58PM +0200, Nikolay Borisov wrote:
> On  9.11.2017 17:45, Anand Jain wrote:
> > A preparation patch to create the actual device open in a new function.
> Just say you are reducing the visibility of some variables to the loop.

This patch is IMHO too fine-grained and can be folded with the last one.
A preparatory change like this would make sense if there are some
non-obvious consequences, but here it's just moving the declaration
block to a new function, that was easy to review.
