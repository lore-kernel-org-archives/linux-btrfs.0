Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53667 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3AXR4l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 12:56:41 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so7074719lbb.13
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2013 09:56:40 -0800 (PST)
Message-ID: <510175F7.5080806@gmail.com>
Date: Thu, 24 Jan 2013 18:57:11 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Eric Sandeen <sandeen@redhat.com>, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com> <5100FDA3.3040907@giantdisaster.de>
In-Reply-To: <5100FDA3.3040907@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/24/2013 10:23 AM, Stefan Behrens wrote:
> On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
>> instead of renaming&  keeping the btrfsctl.c copy
>
> There is a new momentum to improve the Btrfs-progs quality :)
>
> IMO, one step is to get rid of the legacy tools and sources. It wastes
> time to maintain them and these old tools cause confusion. btrfsctl.c,
> btrfs-vol.c and btrfs-show.c are not needed anymore. Please correct me
> if there are plans to use these old tools in future Linux distributions.
> The "btrfs" tool replaces the legacy "btrfsctl", "btrfs-vol" and
> "btrfs-show" tools. Below, the usage text of the old tools is quoted.
> All these tasks are also offered in the "btrfs" tool, and this tool is
> the newer one.

I fully agree: btrfsctl, btrfs-vol, btrfs-show are perfectly replaced by 
by btrfs. Moreover time to time the patches are more complex than the 
needing because exists these "legacy" programs.

I checked the debian package, and to me seems that there is no need of 
{btrfsctl,btrfs-vol,btrfs-show}

BR
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
