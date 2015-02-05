Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbbBEVIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 16:08:40 -0500
Message-ID: <54D3DBD3.80701@redhat.com>
Date: Thu, 05 Feb 2015 15:08:35 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: allow CFLAGS specification in new build
References: <54D3D31D.40802@redhat.com>
In-Reply-To: <54D3D31D.40802@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/5/15 2:31 PM, Eric Sandeen wrote:
> Disclaimer: I am not an auto$FOO expert by any means.
> 
> But I could find no way to specify additional CFLAGS, and I think
> that this is because they are hard-coded in configure.ac.
> 
> The below works for me, but I don't know if it's the right solution...

gah, looking at the wrong branch in git.  Never mind.

-Eric

