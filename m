Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3HBVqS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 17:46:18 -0400
Date: Fri, 2 Aug 2013 14:46:07 -0700
From: Zach Brown <zab@redhat.com>
To: Mike Audia <mikey_a@gmx.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        sbehrens@giantdisaster.de
Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
Message-ID: <20130802214607.GG12314@lenny.home.zabbo.net>
References: <20130802212552.119430@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130802212552.119430@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Another newbie question is which version of the kernel do I need to
> have in order to cleanly apply this patch?  I am finding that it fails
> to apply to the current stable kernel code (as of now it is v3.10.4)
> which makes me think your patch has to be applied to a newer one?  Are
> you patching against the linux git tree meaning I have to use the 3.11
> series to try your code?

Try Josef's btrfs-next repo:

  https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Integration_repository_.28btrfs-next.29

- z
