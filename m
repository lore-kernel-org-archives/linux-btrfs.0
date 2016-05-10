Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbcEJUXL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 16:23:11 -0400
Subject: Re: Idea on compatibility for old distributions
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.com>,
        Mark Fasheh <mfasheh@suse.de>
References: <d527a25c-c1f5-1329-1ed7-c84229a50251@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ff2d7c7e-26c7-46dd-1372-b40e79f53b88@redhat.com>
Date: Tue, 10 May 2016 15:23:07 -0500
MIME-Version: 1.0
In-Reply-To: <d527a25c-c1f5-1329-1ed7-c84229a50251@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/9/16 8:16 PM, Qu Wenruo wrote:
> Hi David, Mark,
> 
> In the recent test for new btrfs-convert backward compatibility, I
> found that cmds-fi-du.c uses FIEMAP_EXTENT_SHARED bits, which is not
> present in kernel of old distributions like RHEL6 (Sorry, didn't test
> on openSUSE equivalent).

There is really no need to invest in compatibility with such old
distros IMHO.  As Phoronix breathlessly points out today, the tech preview
of btrfs in RHEL6 has ended, and it is now deprecated in RHEL6.
RHEL6-era btrfs was an interesting experiment, but it is one that will
not continue.

Thanks,
-Eric
